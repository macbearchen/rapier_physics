let rapier_exports;

window.rapier_init = async function() {
    const response = await fetch('rapier_ffi.wasm');
    const buffer = await response.arrayBuffer();
    const { instance } = await WebAssembly.instantiate(buffer, {});
    rapier_exports = instance.exports;
    console.log("Rapier WASM loaded", rapier_exports);
};

window.rapier_version = () => {
    const ptr = rapier_exports.rapier_version();
    const memory = new Uint8Array(rapier_exports.memory.buffer);
    let str = "";
    let i = ptr;
    while (memory[i] !== 0) {
        str += String.fromCharCode(memory[i]);
        i++;
    }
    return str;
};

window.rapier_world_create = () => rapier_exports.rapier_world_create();
window.rapier_world_destroy = (world) => rapier_exports.rapier_world_destroy(world);
window.rapier_world_set_gravity = (world, x, y, z) => rapier_exports.rapier_world_set_gravity(world, x, y, z);
window.rapier_world_step = (world) => rapier_exports.rapier_world_step(world);

window.rapier_create_rigid_body = (world, x, y, z, type) => 
    rapier_exports.rapier_create_rigid_body(world, x, y, z, type);

window.rapier_create_box_collider = (world, body, hx, hy, hz) => 
    rapier_exports.rapier_create_box_collider(world, body, hx, hy, hz);

window.rapier_create_sphere_collider = (world, body, radius) => 
    rapier_exports.rapier_create_sphere_collider(world, body, radius);

window.rapier_create_cylinder_collider = (world, body, hh, r) => 
    rapier_exports.rapier_create_cylinder_collider(world, body, hh, r);

window.rapier_create_cone_collider = (world, body, hh, r) => 
    rapier_exports.rapier_create_cone_collider(world, body, hh, r);

window.rapier_create_capsule_collider = (world, body, hh, r) => 
    rapier_exports.rapier_create_capsule_collider(world, body, hh, r);

window.rapier_create_heightfield_collider = (world, body, heights, nrows, ncols, sx, sy, sz) => {
    const len = nrows * ncols;
    const size = len * 4;
    const ptr = rapier_exports.rapier_malloc(size);
    const heap = new Float32Array(rapier_exports.memory.buffer, ptr, len);
    heap.set(heights);
    rapier_exports.rapier_create_heightfield_collider(world, body, ptr, nrows, ncols, sx, sy, sz);
    rapier_exports.rapier_free(ptr, size);
};

window.rapier_malloc = (size) => rapier_exports.rapier_malloc(size);
window.rapier_free = (ptr, size) => rapier_exports.rapier_free(ptr, size);

window.rapier_create_fixed_joint = (world, b1, b2, a1x, a1y, a1z, r1x, r1y, r1z, r1w, a2x, a2y, a2z, r2x, r2y, r2z, r2w) =>
    rapier_exports.rapier_create_fixed_joint(world, b1, b2, a1x, a1y, a1z, r1x, r1y, r1z, r1w, a2x, a2y, a2z, r2x, r2y, r2z, r2w);

window.rapier_create_spherical_joint = (world, b1, b2, a1x, a1y, a1z, a2x, a2y, a2z) =>
    rapier_exports.rapier_create_spherical_joint(world, b1, b2, a1x, a1y, a1z, a2x, a2y, a2z);

window.rapier_create_revolute_joint = (world, b1, b2, vx, vy, vz, a1x, a1y, a1z, a2x, a2y, a2z) =>
    rapier_exports.rapier_create_revolute_joint(world, b1, b2, vx, vy, vz, a1x, a1y, a1z, a2x, a2y, a2z);

window.rapier_create_prismatic_joint = (world, b1, b2, vx, vy, vz, a1x, a1y, a1z, a2x, a2y, a2z) =>
    rapier_exports.rapier_create_prismatic_joint(world, b1, b2, vx, vy, vz, a1x, a1y, a1z, a2x, a2y, a2z);

window.rapier_create_generic_joint = (world, b1, b2, a1x, a1y, a1z, a2x, a2y, a2z) =>
    rapier_exports.rapier_create_generic_joint(world, b1, b2, a1x, a1y, a1z, a2x, a2y, a2z);

window.rapier_create_rope_joint = (world, b1, b2, a1x, a1y, a1z, a2x, a2y, a2z, maxDist) =>
    rapier_exports.rapier_create_rope_joint(world, b1, b2, a1x, a1y, a1z, a2x, a2y, a2z, maxDist);

window.rapier_joint_lock_axis = (world, joint, axis, locked) =>
    rapier_exports.rapier_joint_lock_axis(world, joint, axis, locked);

window.rapier_joint_set_limits = (world, joint, axis, min, max) =>
    rapier_exports.rapier_joint_set_limits(world, joint, axis, min, max);

window.rapier_joint_configure_motor = (world, joint, axis, targetPos, targetVel, stiffness, damping) =>
    rapier_exports.rapier_joint_configure_motor(world, joint, axis, targetPos, targetVel, stiffness, damping);

window.rapier_joint_configure_revolute_motor = (world, joint, targetPos, targetVel, stiffness, damping) =>
    rapier_exports.rapier_joint_configure_revolute_motor(world, joint, targetPos, targetVel, stiffness, damping);

window.rapier_joint_configure_prismatic_motor = (world, joint, targetPos, targetVel, stiffness, damping) =>
    rapier_exports.rapier_joint_configure_prismatic_motor(world, joint, targetPos, targetVel, stiffness, damping);

// Component-wise getters
window.rapier_get_body_position_x = (world, body) => rapier_exports.rapier_get_body_position_x(world, body);
window.rapier_get_body_position_y = (world, body) => rapier_exports.rapier_get_body_position_y(world, body);
window.rapier_get_body_position_z = (world, body) => rapier_exports.rapier_get_body_position_z(world, body);

window.rapier_get_body_rotation_x = (world, body) => rapier_exports.rapier_get_body_rotation_x(world, body);
window.rapier_get_body_rotation_y = (world, body) => rapier_exports.rapier_get_body_rotation_y(world, body);
window.rapier_get_body_rotation_z = (world, body) => rapier_exports.rapier_get_body_rotation_z(world, body);
window.rapier_get_body_rotation_w = (world, body) => rapier_exports.rapier_get_body_rotation_w(world, body);

window.rapier_set_body_position = (world, body, x, y, z) => 
    rapier_exports.rapier_set_body_position(world, body, x, y, z);

window.rapier_set_body_rotation = (world, body, x, y, z, w) => 
    rapier_exports.rapier_set_body_rotation(world, body, x, y, z, w);

window.rapier_wake_body = (world, body) => 
    rapier_exports.rapier_wake_body(world, body);