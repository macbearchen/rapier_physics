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

window.rapier_create_capsule_collider = (world, body, hh, r) => 
    rapier_exports.rapier_create_capsule_collider(world, body, hh, r);

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