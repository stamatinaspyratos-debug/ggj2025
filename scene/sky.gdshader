shader_type sky;
render_mode use_debanding;

uniform vec3 zenith_color : source_color = vec3(0.02, 0.03, 0.07);   // πάνω (σκούρο μπλε)
uniform vec3 horizon_color : source_color = vec3(0.05, 0.05, 0.10);  // ορίζοντας
uniform vec3 ground_color : source_color = vec3(0.005, 0.005, 0.01); // κάτω (σχεδόν μαύρο)

uniform float horizon_power : hint_range(0.2, 6.0) = 2.2;

uniform float star_density : hint_range(0.0, 1.0) = 0.20;    // πόσα αστέρια
uniform float star_brightness : hint_range(0.0, 3.0) = 1.2;  // πόσο φωτεινά
uniform float star_size : hint_range(0.2, 3.0) = 1.0;        // “μεγέθη” stars
uniform float twinkle : hint_range(0.0, 1.0) = 0.15;         // 0 = static, >0 = ελαφρύ τρεμόπαιγμα

float hash(vec3 p) {
	p = fract(p * 0.3183099 + vec3(0.1, 0.2, 0.3));
	p *= 17.0;
	return fract(p.x * p.y * p.z * (p.x + p.y + p.z));
}

void sky() {
	vec3 dir = normalize(EYEDIR);

	// --- Gradient (PS2-ish) ---
	float y = clamp(dir.y * 0.5 + 0.5, 0.0, 1.0); // 0..1
	float h = pow(1.0 - abs(dir .y), horizon_power); // πιο έντονος ορίζοντας

	vec3 col = mix(ground_color, zenith_color, y);
	col = mix(col, horizon_color, h);

	// --- Stars (μόνο στον ουρανό, όχι κάτω) ---
	if (dir.y > 0.02) {
		// Κάνουμε quantization για “pixel” αίσθηση (PS2 vibe)
		vec3 q = floor(dir * (120.0 * star_size)) / (120.0 * star_size);

		float n = hash(q * 31.0);

		// threshold: όσο πιο μικρό τόσο περισσότερα stars
		float threshold = 1.0 - star_density;
		float star = step(threshold, n);

		// λίγο twinkle (αν θες)
		float t = 1.0;
		if (twinkle > 0.0) {
			t = 0.7 + 0.3 * sin(TIME * 6.0 + n * 40.0);
			t = mix(1.0, t, twinkle);
		}

		col += vec3(star) * star_brightness * t;
	}

	COLOR = col;
	ALPHA = 1.0;
}
