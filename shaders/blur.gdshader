shader_type canvas_item;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;
uniform float blur_amount : hint_range(0.0, 10.0) = 2.0;
uniform int num_samples : hint_range(16, 64) = 45; // Configurable number of angle samples
uniform int num_rings : hint_range(2, 8) = 4; // Configurable number of rings
uniform float smoothness : hint_range(0.1, 2.0) = 1.0; // Controls the smoothness of the blur

void fragment() {
    vec2 pixel_size = 1.0 / vec2(textureSize(SCREEN_TEXTURE, 0));
    vec2 uv = SCREEN_UV;
    vec4 color = vec4(0.0);
    float total_weight = 0.0;

    // Center sample with higher weight for better detail preservation
    color += texture(SCREEN_TEXTURE, uv) * 1.0;
    total_weight += 1.0;

    // Circular sampling with configurable samples and rings
    float angle_step = 6.28318 / float(num_samples);
    for(float angle = 0.0; angle < 6.28318; angle += angle_step) {
        for(float d = 1.0; d <= float(num_rings); d++) {
            float radius = (d / float(num_rings)) * blur_amount * 3.0;

            // Smooth step for better weight distribution
            float weight = smoothstep(float(num_rings), 1.0, d) * smoothness;

            // Inner samples
            vec2 offset = vec2(cos(angle), sin(angle)) * pixel_size * radius;
            color += texture(SCREEN_TEXTURE, uv + offset) * weight;

            // Outer samples with slight offset for better antialiasing
            vec2 offset2 = vec2(cos(angle + angle_step * 0.5), sin(angle + angle_step * 0.5)) * pixel_size * radius;
            color += texture(SCREEN_TEXTURE, uv + offset2) * (weight * 0.5);

            total_weight += weight * 1.5;
        }
    }

    vec4 blur = color / total_weight;
    vec4 original = texture(TEXTURE, UV);

    // Smooth blend between blur and original
    COLOR = blur * original;
}
