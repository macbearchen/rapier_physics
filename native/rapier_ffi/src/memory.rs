use std::alloc::{alloc, dealloc, Layout};

#[no_mangle]
pub extern "C" fn rapier_malloc(size: usize) -> *mut u8 {
    let layout = Layout::from_size_align(size, 8).unwrap();
    unsafe { alloc(layout) }
}

#[no_mangle]
pub extern "C" fn rapier_free(ptr: *mut u8, size: usize) {
    if !ptr.is_null() {
        let layout = Layout::from_size_align(size, 8).unwrap();
        unsafe { dealloc(ptr, layout) }
    }
}
