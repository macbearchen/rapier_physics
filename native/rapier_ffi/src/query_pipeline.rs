use crate::types::{ColliderDesc, PointProjectionC, RapierWorld, RayIntersectionC, ShapeCastHitC};
use rapier3d::na::{Isometry3 as Isometry, Translation3 as Translation, Quaternion, UnitQuaternion};
use rapier3d::parry::query::ShapeCastOptions;
use rapier3d::prelude::*;

const NO_EXCLUSION: u32 = u32::MAX;

fn make_rotation(x: f32, y: f32, z: f32, w: f32) -> UnitQuaternion<f32> {
    if x == 0.0 && y == 0.0 && z == 0.0 && w == 0.0 {
        UnitQuaternion::identity()
    } else {
        UnitQuaternion::from_quaternion(Quaternion::new(w, x, y, z))
    }
}

fn build_shape(desc: &ColliderDesc) -> SharedShape {
    match desc.shape_type {
        0 => SharedShape::cuboid(desc.hx, desc.hy, desc.hz),
        1 => SharedShape::ball(desc.radius),
        2 => SharedShape::cylinder(desc.half_height, desc.radius),
        3 => SharedShape::cone(desc.half_height, desc.radius),
        4 => SharedShape::capsule_x(desc.half_height, desc.radius),
        5 => SharedShape::capsule_y(desc.half_height, desc.radius),
        6 => SharedShape::capsule_z(desc.half_height, desc.radius),
        _ => SharedShape::cuboid(desc.hx, desc.hy, desc.hz),
    }
}

fn get_parent_body_handle(world: &RapierWorld, collider_handle: ColliderHandle) -> u32 {
    world
        .colliders
        .get(collider_handle)
        .and_then(|c| c.parent())
        .map(|p| p.into_raw_parts().0)
        .unwrap_or(0)
}

fn sync_colliders_and_broad_phase(world: &mut RapierWorld) {
    // 1. Synchronize collider world-space positions with parent rigid bodies
    for (_handle, collider) in world.colliders.iter_mut() {
        if let Some(parent) = collider.parent() {
            if let Some(body) = world.bodies.get(parent) {
                let parent_pos = body.position();
                let local_pos = collider.position_wrt_parent().copied().unwrap_or_else(Pose3::identity);
                collider.set_position(parent_pos * local_pos);
            }
        }
    }

    // 2. Update dedicated query broad phase BVH so simulation broad phase is not affected
    let all_handles: Vec<ColliderHandle> = world.colliders.iter().map(|(h, _)| h).collect();
    world.query_broad_phase.update(
        &world.integration_parameters,
        &world.colliders,
        &world.bodies,
        &all_handles,
        &all_handles,
        &mut Vec::new(),
    );
}

fn build_query_pipeline<'a>(
    world: &'a mut RapierWorld,
    exclude_collider: u32,
    exclude_rigid_body: u32,
) -> rapier3d::pipeline::QueryPipeline<'a> {
    sync_colliders_and_broad_phase(world);

    let mut filter = QueryFilter::default();
    if exclude_collider != NO_EXCLUSION {
        filter = filter.exclude_collider(ColliderHandle::from_raw_parts(exclude_collider, 0));
    }
    if exclude_rigid_body != NO_EXCLUSION {
        filter = filter.exclude_rigid_body(RigidBodyHandle::from_raw_parts(exclude_rigid_body, 0));
    }

    world.query_broad_phase.as_query_pipeline(
        world.narrow_phase.query_dispatcher(),
        &world.bodies,
        &world.colliders,
        filter,
    )
}


#[no_mangle]
pub extern "C" fn rapier_world_cast_ray(
    world: *mut RapierWorld,
    ox: f32,
    oy: f32,
    oz: f32,
    dx: f32,
    dy: f32,
    dz: f32,
    max_toi: f32,
    solid: bool,
    exclude_collider: u32,
    exclude_rigid_body: u32,
) -> RayIntersectionC {
    let world = unsafe { &mut *world };
    let query_pipeline = build_query_pipeline(world, exclude_collider, exclude_rigid_body);
    let ray = Ray::new(point![ox, oy, oz].into(), vector![dx, dy, dz].into());

    if let Some((handle, toi)) = query_pipeline.cast_ray(&ray, max_toi, solid) {
        let rb_handle = get_parent_body_handle(world, handle);
        let hit_pt = ray.point_at(toi);
        RayIntersectionC {
            collider_handle: handle.into_raw_parts().0,
            rigid_body_handle: rb_handle,
            toi,
            point_x: hit_pt.x,
            point_y: hit_pt.y,
            point_z: hit_pt.z,
            normal_x: 0.0,
            normal_y: 0.0,
            normal_z: 0.0,
            hit: true,
        }
    } else {
        RayIntersectionC {
            collider_handle: 0,
            rigid_body_handle: 0,
            toi: 0.0,
            point_x: 0.0,
            point_y: 0.0,
            point_z: 0.0,
            normal_x: 0.0,
            normal_y: 0.0,
            normal_z: 0.0,
            hit: false,
        }
    }
}

#[no_mangle]
pub extern "C" fn rapier_world_cast_ray_and_get_normal(
    world: *mut RapierWorld,
    ox: f32,
    oy: f32,
    oz: f32,
    dx: f32,
    dy: f32,
    dz: f32,
    max_toi: f32,
    solid: bool,
    exclude_collider: u32,
    exclude_rigid_body: u32,
) -> RayIntersectionC {
    let world = unsafe { &mut *world };
    let query_pipeline = build_query_pipeline(world, exclude_collider, exclude_rigid_body);
    let ray = Ray::new(point![ox, oy, oz].into(), vector![dx, dy, dz].into());

    if let Some((handle, intersection)) = query_pipeline.cast_ray_and_get_normal(&ray, max_toi, solid) {
        let rb_handle = get_parent_body_handle(world, handle);
        let hit_pt = ray.point_at(intersection.time_of_impact);
        RayIntersectionC {
            collider_handle: handle.into_raw_parts().0,
            rigid_body_handle: rb_handle,
            toi: intersection.time_of_impact,
            point_x: hit_pt.x,
            point_y: hit_pt.y,
            point_z: hit_pt.z,
            normal_x: intersection.normal.x,
            normal_y: intersection.normal.y,
            normal_z: intersection.normal.z,
            hit: true,
        }
    } else {
        RayIntersectionC {
            collider_handle: 0,
            rigid_body_handle: 0,
            toi: 0.0,
            point_x: 0.0,
            point_y: 0.0,
            point_z: 0.0,
            normal_x: 0.0,
            normal_y: 0.0,
            normal_z: 0.0,
            hit: false,
        }
    }
}

#[no_mangle]
pub extern "C" fn rapier_world_cast_shape(
    world: *mut RapierWorld,
    px: f32,
    py: f32,
    pz: f32,
    rx: f32,
    ry: f32,
    rz: f32,
    rw: f32,
    vx: f32,
    vy: f32,
    vz: f32,
    shape_desc: *const ColliderDesc,
    max_toi: f32,
    stop_at_penetration: bool,
    exclude_collider: u32,
    exclude_rigid_body: u32,
) -> ShapeCastHitC {
    let world = unsafe { &mut *world };
    let query_pipeline = build_query_pipeline(world, exclude_collider, exclude_rigid_body);
    let desc = unsafe { &*shape_desc };
    let shape = build_shape(desc);

    let pose = Isometry::from_parts(
        Translation::new(px, py, pz),
        make_rotation(rx, ry, rz, rw),
    );
    let vel = vector![vx, vy, vz].into();

    let options = ShapeCastOptions {
        max_time_of_impact: max_toi,
        stop_at_penetration,
        target_distance: 0.0,
        compute_impact_geometry_on_penetration: true,
    };

    if let Some((handle, hit)) =
        query_pipeline.cast_shape(&pose.into(), vel, shape.as_ref(), options)
    {
        let rb_handle = get_parent_body_handle(world, handle);
        ShapeCastHitC {
            collider_handle: handle.into_raw_parts().0,
            rigid_body_handle: rb_handle,
            toi: hit.time_of_impact,
            point_x: hit.witness1.x,
            point_y: hit.witness1.y,
            point_z: hit.witness1.z,
            normal_x: hit.normal1.x,
            normal_y: hit.normal1.y,
            normal_z: hit.normal1.z,
            hit: true,
        }
    } else {
        ShapeCastHitC {
            collider_handle: 0,
            rigid_body_handle: 0,
            toi: 0.0,
            point_x: 0.0,
            point_y: 0.0,
            point_z: 0.0,
            normal_x: 0.0,
            normal_y: 0.0,
            normal_z: 0.0,
            hit: false,
        }
    }
}

#[no_mangle]
pub extern "C" fn rapier_world_project_point(
    world: *mut RapierWorld,
    px: f32,
    py: f32,
    pz: f32,
    solid: bool,
    exclude_collider: u32,
    exclude_rigid_body: u32,
) -> PointProjectionC {
    let world = unsafe { &mut *world };

    // Guard: parry3d 0.26 panics with unwrap() on None when project_point is called
    // on an empty BVH (CompositeShape with no leaves). Return no-hit immediately.
    if world.colliders.is_empty() {
        return PointProjectionC {
            collider_handle: 0,
            rigid_body_handle: 0,
            point_x: px,
            point_y: py,
            point_z: pz,
            is_inside: false,
            hit: false,
        };
    }

    let query_pipeline = build_query_pipeline(world, exclude_collider, exclude_rigid_body);
    let pt = point![px, py, pz].into();

    if let Some((handle, proj)) = query_pipeline.project_point(pt, f32::MAX, solid) {
        let rb_handle = get_parent_body_handle(world, handle);
        PointProjectionC {
            collider_handle: handle.into_raw_parts().0,
            rigid_body_handle: rb_handle,
            point_x: proj.point.x,
            point_y: proj.point.y,
            point_z: proj.point.z,
            is_inside: proj.is_inside,
            hit: true,
        }
    } else {
        PointProjectionC {
            collider_handle: 0,
            rigid_body_handle: 0,
            point_x: 0.0,
            point_y: 0.0,
            point_z: 0.0,
            is_inside: false,
            hit: false,
        }
    }
}

#[no_mangle]
pub extern "C" fn rapier_world_intersections_with_point(
    world: *mut RapierWorld,
    px: f32,
    py: f32,
    pz: f32,
    exclude_collider: u32,
    exclude_rigid_body: u32,
    out_colliders: *mut u32,
    max_out_colliders: usize,
) -> usize {
    let world = unsafe { &mut *world };
    let query_pipeline = build_query_pipeline(world, exclude_collider, exclude_rigid_body);
    let pt = point![px, py, pz].into();

    let mut count = 0;
    for (handle, _) in query_pipeline.intersect_point(pt) {
        if count < max_out_colliders && !out_colliders.is_null() {
            unsafe {
                *out_colliders.add(count) = handle.into_raw_parts().0;
            }
        }
        count += 1;
    }

    count
}

#[no_mangle]
pub extern "C" fn rapier_world_intersection_with_shape(
    world: *mut RapierWorld,
    px: f32,
    py: f32,
    pz: f32,
    rx: f32,
    ry: f32,
    rz: f32,
    rw: f32,
    shape_desc: *const ColliderDesc,
    exclude_collider: u32,
    exclude_rigid_body: u32,
) -> u32 {
    let world = unsafe { &mut *world };
    let query_pipeline = build_query_pipeline(world, exclude_collider, exclude_rigid_body);
    let desc = unsafe { &*shape_desc };
    let shape = build_shape(desc);

    let pose = Isometry::from_parts(
        Translation::new(px, py, pz),
        make_rotation(rx, ry, rz, rw),
    );

    let hit = query_pipeline
        .intersect_shape(pose.into(), shape.as_ref())
        .next()
        .map(|(h, _)| h.into_raw_parts().0)
        .unwrap_or(u32::MAX);

    hit
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::world::*;
    use crate::rigid_body::*;
    use crate::collider::*;

    #[test]
    fn test_native_cast_ray() {
        let world = rapier_world_create();

        // Create a fixed rigid body at (0, 0, 5)
        let body_handle = rapier_rigid_body_create(world, 0.0, 0.0, 5.0, 1);

        // Create a cuboid collider of half-extents (1, 1, 1) attached to body
        let desc = ColliderDesc {
            shape_type: 0, // Cuboid
            hx: 1.0, hy: 1.0, hz: 1.0,
            radius: 0.0, half_height: 0.0,
            friction: 0.5, restitution: 0.0, density: 1.0,
            local_position_x: 0.0, local_position_y: 0.0, local_position_z: 0.0,
            local_rotation_x: 0.0, local_rotation_y: 0.0, local_rotation_z: 0.0, local_rotation_w: 1.0,
            is_sensor: false,
        };
        let col_handle = rapier_collider_create(world, body_handle, &desc);

        // Step the world once to build physics pipeline & broad phase BVH
        rapier_world_step(world);

        // Cast ray from (0, 0, 0) along (0, 0, 1)
        let hit = rapier_world_cast_ray(world, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 10.0, true, u32::MAX, u32::MAX);


        println!("hit: {:?}", hit);
        assert!(hit.hit, "Ray should hit the box at z=5");
        assert_eq!(hit.collider_handle, col_handle);
        assert_eq!(hit.rigid_body_handle, body_handle);
        assert!((hit.toi - 4.0).abs() < 1e-3);

        rapier_world_destroy(world);
    }

    #[test]
    fn test_fall_with_raycast_query() {
        let world = rapier_world_create();
        rapier_world_set_gravity(world, 0.0, 0.0, -9.81);

        // Ground at z = -0.5 with half-height 0.5 (top at z = 0)
        let ground_body = rapier_rigid_body_create(world, 0.0, 0.0, -0.5, 1);
        let ground_desc = ColliderDesc {
            shape_type: 0,
            hx: 10.0, hy: 10.0, hz: 0.5,
            radius: 0.0, half_height: 0.0,
            friction: 0.5, restitution: 0.0, density: 1.0,
            local_position_x: 0.0, local_position_y: 0.0, local_position_z: 0.0,
            local_rotation_x: 0.0, local_rotation_y: 0.0, local_rotation_z: 0.0, local_rotation_w: 1.0,
            is_sensor: false,
        };
        rapier_collider_create(world, ground_body, &ground_desc);

        // Dynamic sphere at z = 5.0, radius 0.8
        let sphere_body = rapier_rigid_body_create(world, 0.0, 0.0, 5.0, 0);
        let sphere_desc = ColliderDesc {
            shape_type: 1,
            hx: 0.0, hy: 0.0, hz: 0.0,
            radius: 0.8, half_height: 0.0,
            friction: 0.5, restitution: 0.0, density: 1.0,
            local_position_x: 0.0, local_position_y: 0.0, local_position_z: 0.0,
            local_rotation_x: 0.0, local_rotation_y: 0.0, local_rotation_z: 0.0, local_rotation_w: 1.0,
            is_sensor: false,
        };
        rapier_collider_create(world, sphere_body, &sphere_desc);

        // Step for 120 frames (2 seconds) with raycasting on every frame
        for _ in 0..120 {
            // Raycast every frame
            let _hit = rapier_world_cast_ray_and_get_normal(
                world,
                0.0, 0.0, 3.0,
                0.0, 1.0, -0.6,
                15.0,
                true,
                u32::MAX,
                u32::MAX,
            );

            rapier_world_step(world);
        }

        let pos = rapier_rigid_body_get_position(world, sphere_body);
        println!("Sphere final z: {}", pos.z);
        // Sphere has radius 0.8, ground top is 0.0 -> resting z should be around 0.8
        assert!(pos.z >= 0.7 && pos.z <= 0.9, "Sphere should rest on ground, but got z = {}", pos.z);

        rapier_world_destroy(world);
    }
}

