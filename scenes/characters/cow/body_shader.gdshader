shader_type canvas_item;

// Base colors
uniform vec4 body_color   : source_color = vec4(0.9, 0.8, 0.7, 1.0);
uniform vec4 spot_color   : source_color = vec4(0.5, 0.4, 0.3, 1.0);
// Additional colors for muzzle, horns, hooves, etc.
uniform vec4 muzzle_color : source_color = vec4(1.0, 0.8, 0.7, 1.0);
uniform vec4 horn_color   : source_color = vec4(0.2, 0.2, 0.2, 1.0);
uniform vec4 hoof_color   : source_color = vec4(0.3, 0.2, 0.15, 1.0);

// Random spot settings
uniform float spot_density : hint_range(0.0, 1.0) = 0.3;
uniform float spot_scale   : hint_range(1.0, 10.0) = 4.0;

// "Pixel grid" settings
uniform float resolution   : hint_range(1.0, 512.0) = 64.0;
uniform float pixel_scale  : hint_range(1.0, 10.0) = 1.0;

// Random function
float rand(vec2 co) {
    return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    // Convert UV to an integer-like pixel grid
    vec2 pix = floor(UV * resolution * pixel_scale);
    float x = pix.x;
    float y = pix.y;

    //-----------------------------------
    // 1) BODY (side-view elliptical shape)
    //-----------------------------------
    // Center the body around (32, 30)
    // Wider radius in x than y
    vec2 body_center = vec2(32.0, 30.0);
    vec2 body_radius = vec2(16.0, 12.0);
    vec2 body_dist   = (pix - body_center) / body_radius;
    bool in_body     = (dot(body_dist, body_dist) <= 1.0);

    //-------------------------------------
    // 2) HEAD (circle or ellipse on the side)
    //-------------------------------------
    // Shift the head to the right side
    vec2 head_center = vec2(48.0, 28.0);
    vec2 head_radius = vec2(6.0, 6.0);
    vec2 head_dist   = (pix - head_center) / head_radius;
    bool in_head     = (dot(head_dist, head_dist) <= 1.0);

    //-------------------------------------
    // 3) MUZZLE (small circle offset on the head)
    //-------------------------------------
    // For a side muzzle, place it further right and possibly lower.
    vec2 muzzle_center = head_center + vec2(3.5, 1.0);
    float muzzle_r     = 2.0; // tweak for muzzle size
    bool in_muzzle     = (distance(pix, muzzle_center) <= muzzle_r);

    //-------------------------
    // 4) HORNS (two small circles)
    //-------------------------
    // Above the head, spaced left/right
    vec2 horn_left_center  = head_center + vec2(-3.0, -4.0);
    vec2 horn_right_center = head_center + vec2( 1.0, -4.0);
    float horn_radius      = 1.5;
    bool in_horn_left      = (distance(pix, horn_left_center)  <= horn_radius);
    bool in_horn_right     = (distance(pix, horn_right_center) <= horn_radius);

    //----------------
    // 5) EARS (circles or rectangles)
    //----------------
    // For a side-view, place one ear behind the horns (small circle).
    // If you want two ears, offset them differently.
    vec2 ear_center = head_center + vec2(-3.0, -2.0);
    float ear_r     = 1.5;
    bool in_ear     = (distance(pix, ear_center) <= ear_r);

    //----------
    // 6) TAIL
    //----------
    // A small vertical rectangle near the back of the body, or a tiny circle.
    // We'll do a rectangle for a simple "flick" tail.
    // Tweak x-range to place it behind the body, e.g. near x=17
    bool in_tail = (x >= 16.0 && x < 18.0 && y >= 22.0 && y < 28.0);

    //----------------------------
    // 7) LEGS & HOOVES (rectangles)
    //----------------------------
    // Option: two or four legs. We'll do two for a side-view silhouette:
    bool front_leg = (x >= 28.0 && x < 30.0 && y >= 40.0 && y < 46.0);
    bool back_leg  = (x >= 20.0 && x < 22.0 && y >= 40.0 && y < 46.0);

    // Hooves at the bottom of each leg.
    // Each hoof is the bottom 2 "pixels" of the leg region.
    bool front_hoof = (x >= 28.0 && x < 30.0 && y >= 46.0 && y < 48.0);
    bool back_hoof  = (x >= 20.0 && x < 22.0 && y >= 46.0 && y < 48.0);

    //-------------------------------------------
    // Combine shapes with a priority-based approach
    //-------------------------------------------
    vec4 color = vec4(0.0);

    // Priority suggestions (from top to bottom):
    // horns > ears > muzzle > head > body > tail > legs > hooves
    // or reorder if you like.

    // HORNS
    if (in_horn_left || in_horn_right) {
        color = horn_color;
    }
    // EARS
    else if (in_ear) {
        color = body_color; // same as body or a slightly darker shade if you want
    }
    // MUZZLE
    else if (in_muzzle) {
        color = muzzle_color; // pinkish or a slight variation
    }
    // HEAD
    else if (in_head) {
        color = body_color; // no spots on the head, typically
    }
    // BODY
    else if (in_body) {
        color = body_color;
        // Random spots only on the body
        float spot_val = rand(floor(pix / spot_scale));
        if (spot_val < spot_density) {
            color = spot_color;
        }
    }
    // TAIL
    else if (in_tail) {
        color = body_color; // same color, or you can do a tuft at the tip
    }
    // LEGS
    else if (front_leg || back_leg) {
        color = body_color;
    }
    // HOOVES
    else if (front_hoof || back_hoof) {
        color = hoof_color; // dark brown
    }
    // Else transparent
    else {
        color.a = 0.0;
    }

    COLOR = color;
}
