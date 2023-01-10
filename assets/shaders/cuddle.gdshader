shader_type canvas_item;

uniform float time;
uniform vec2 resolution;

void fragment() {
    // Normalized pixel coordinates (from 0 to 1)
    vec2 uv = UV;
    vec2 p = (FRAGCOORD.xy / resolution.xy) * 2.0 - 1.0;
    p.x *= resolution.x / resolution.y;

    // Use the current time to animate the effect
    float t = time;

    // Create a "wave" pattern using a sine function
    float wave = sin(p.x * 2.0 + t * 5.0);
    wave += sin(p.y * 2.0 + t * 5.0);
    wave *= 0.5;

    // Displace the UV coordinates based on the wave pattern
    uv.x += wave * 0.05;
    uv.y += wave * 0.05;

    // Sample the texture
    vec4 col = texture(TEXTURE, uv);

    // Output the final color
    COLOR = col;
}