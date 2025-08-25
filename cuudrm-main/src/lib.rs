mod utils;

use wasm_bindgen::prelude::*;
use web_sys::console;
use base64::decode;

// When the `wee_alloc` feature is enabled, use `wee_alloc` as the global
// allocator.
#[cfg(feature = "wee_alloc")]
#[global_allocator]
static ALLOC: wee_alloc::WeeAlloc = wee_alloc::WeeAlloc::INIT;

#[wasm_bindgen]
pub fn render_image(obfuscated_image: &web_sys::HtmlImageElement, ctx: &web_sys::CanvasRenderingContext2d, drm_data: String) {
    let window = web_sys::window().expect("invalid environment");
    let document = window.document().expect("invalid environment");
    let phrase_el_result = document.query_selector("#phrase");

    if let Ok(phrase_el_option) = phrase_el_result {
        if let Some(phrase_el) = phrase_el_option {
            let phrase = phrase_el.inner_html().trim().to_string();
            let decrypted_data = decrypt_drm_data(drm_data);

            if phrase == "unionize-assume-swarthy-polo" {
                let mut acc_height = 0;
                let image_width = obfuscated_image.width();

                for part in decrypted_data.iter() {
                    let sx: f64 = 0 as f64;
                    let sy: f64 = acc_height as f64;
                    let sw: f64 = image_width as f64;
                    let sh: f64 = part[1] as f64;
                    let dx: f64 = 0 as f64;
                    let dy: f64 = part[0] as f64;
                    let dw: f64 = image_width as f64;
                    let dh: f64 = part[1] as f64;

                    ctx.draw_image_with_html_image_element_and_sw_and_sh_and_dx_and_dy_and_dw_and_dh(
                        obfuscated_image, sx, sy, sw, sh, dx, dy, dw, dh
                    ).unwrap();

                    acc_height += part[1];
                }
            }
        }
    }
}

pub fn decrypt_drm_data(drm_data: String) -> (Vec<Vec<u32>>) {
    let pi = std::f64::consts::PI;
    let pi_flat = (pi as f64) * ((10 as i64).pow(15) as f64).floor();
    let pi_flat_str = pi_flat.to_string();
    let pi_flat_bytes = pi_flat_str.into_bytes();

    let mut drm_data_bytes = decode(remove_whitespace(&drm_data)).expect("Failed to decode base64 from drm data string.");
    
    let mut pi_pos = 0;
    for byte in drm_data_bytes.iter_mut() {
        *byte = *byte ^ pi_flat_bytes[pi_pos];
        
        if pi_pos < 15 {
            pi_pos += 1;
        } else {
            pi_pos = 0;
        }
    }

    let decrypted_str = String::from_utf8(drm_data_bytes).expect("Failed to decrypt DRM data string to original data.");
    let mut decrypted_vec: Vec<&str> = decrypted_str.split("|").collect();

    if decrypted_vec.first().unwrap().to_string() == "#v2".to_string() {
        decrypted_vec.drain(..1);
    }

    let result_vec: Vec<Vec<u32>> = decrypted_vec.iter().map(|item| item.split("-").map(|x| x.parse().unwrap()).collect()).collect();
    result_vec
}

fn remove_whitespace(s: &str) -> String {
    s.chars().filter(|c| !c.is_whitespace()).collect()
}
