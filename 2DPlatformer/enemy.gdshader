// This is a 2D CanvasItem shader
shader_type canvas_item;

// Uniforms for configuration
uniform float top = 1.0;                      // Top of the blob area
uniform float bottom = 0.0;                   // Bottom of the blob area
uniform float blob_threshold = 1.5;           // Threshold for blob visibility
uniform float random_seed = 0.0;              // Unique random seed per object
uniform float blob_scale_x = 1.0;             // Scale factor for blob size (X axis)
uniform float blob_scale_y = 1.0;             // Scale factor for blob size (Y axis)
uniform bool blobs_enabled = true;            // Enable or disable blobs
uniform float blob_speed = 1.0;               // Speed of the blob movement

// Background gradient colors with adjustable alpha
uniform vec4 background_edge : source_color = vec4(0.1, 0.0, 0.2, 1.0);
uniform vec4 background_center : source_color = vec4(0.5, 0.0, 0.8, 1.0);
uniform float background_alpha = 0.5;         // Background transparency (0.0 to 1.0)

// Blob gradient colors with adjustable alpha
uniform vec4 blob_top : source_color = vec4(1.0, 0.4, 0.4, 1.0);
uniform vec4 blob_bottom : source_color = vec4(1.0, 1.0, 0.3, 1.0);
uniform float blob_alpha = 1.0;               // Blob transparency (0.0 to 1.0)

// Function to generate a pseudo-random value based on seed
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233)) + random_seed) * 43758.5453123);
}

// Function to calculate oscillation for blob movement
float oscillate(float time, float offset, float speed) {
    return 0.5 + 0.5 * sin(time * speed + offset);
}

void fragment() {
    // Sample the base texture and respect its transparency
    vec4 base_color = texture(TEXTURE, UV);
    float base_alpha = base_color.a; // Use the alpha of the base texture

    // Background gradient based on UV.x
    vec4 background_color = mix(background_edge, background_center, abs(0.5 - UV.x) * 2.0);
    background_color.a *= background_alpha; // Apply adjustable background transparency

    // If blobs are disabled, show only the background
    if (!blobs_enabled) {
        COLOR = background_color * base_alpha; // Combine with base texture transparency
    } else {
        // Blob centers and radii (fixed size array)
        const int blob_count = 6;
        vec3 blob_centers[blob_count];
        for (int i = 0; i < blob_count; i++) {
            float random_offset = random(vec2(float(i), 0.0)); // Random per blob
            blob_centers[i] = vec3(
                0.4 + 0.2 * random(vec2(float(i), 1.0)), // X position with some randomization
                bottom + oscillate(TIME, random_offset, blob_speed * (0.1 + 0.3 * random(vec2(float(i), 2.0)))) * (top - bottom), // Ensure blobs start at bottom and move up
                0.03 + 0.05 * random(vec2(float(i), 3.0)) // Base radius (without scaling)
            );
        }

        // Calculate blob influence with independent X and Y scaling
        float influence = 0.0;
        for (int i = 0; i < blob_count; i++) {
            vec2 scaled_uv = vec2(UV.x / blob_scale_x, UV.y / blob_scale_y);
            vec2 scaled_center = vec2(blob_centers[i].x / blob_scale_x, blob_centers[i].y / blob_scale_y);
            float distance_to_blob = distance(scaled_uv, scaled_center);
            influence += blob_centers[i].z / (distance_to_blob + 0.01); // Avoid division by zero
        }

        // Adjusted blob color blending to apply gradient from bottom to top
        float gradient_position = clamp((UV.y - bottom) / (top - bottom), 0.0, 1.0);
        vec4 blob_color = mix(blob_bottom, blob_top, gradient_position);
        blob_color.a *= blob_alpha; // Apply adjustable blob transparency

        // Determine the final color based on influence
        vec4 final_color = background_color;
        if (influence > blob_threshold) {
            final_color = blob_color;
        } else {
            final_color = mix(background_color, blob_color, pow(influence / blob_threshold, 2.0));
        }

        // Combine with the base texture transparency
        final_color.a *= base_alpha;

        // Output the final color
        COLOR = final_color;
    }
}

