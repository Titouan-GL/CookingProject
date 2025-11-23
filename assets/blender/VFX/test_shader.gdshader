shader_type particles;

uniform vec3 points[3];
uniform sampler2D alpha;

vec3 getInterpolation(float i, vec3 p1, vec3 p2)
{
	vec3 dif = p2 - p1;
	return p1 + dif * i;
}

vec3 getBezier(float i, vec3 p1, vec3 p2, vec3 p3)
{
	vec3 ip1 = getInterpolation(i, p1, p2);
	vec3 ip2 = getInterpolation(i, p2, p3);
	vec3 ip3 = getInterpolation(i, ip1, ip2);
	
	return ip3;
}

mat4 getRotationY(float a)
{;
	mat4 m = mat4(
		vec4( cos(a), 0.0, -sin(a), 0.0 ),
		vec4( 0.0,    1.0, 0.0,     0.0 ),
		vec4( sin(a), 0.0, cos(a),  0.0 ),
		vec4( 0.0,    0.0, 0.0,     1.0 )
	);
	
	return m;
}

mat4 getRotationX(float a)
{;
	mat4 m = mat4(
		vec4( 1.0,     0.0,    0.0, 0.0 ),
		vec4( 0.0,  cos(a), sin(a), 0.0 ),
		vec4( 0.0, -sin(a), cos(a), 0.0 ),
		vec4( 0.0,     0.0,    0.0, 1.0 )
	);
	
	return m;
}

void start() {
	if (RESTART_POSITION)
	{
		TRANSFORM = getRotationY(PI);
		TRANSFORM = TRANSFORM * EMISSION_TRANSFORM;
	}
	if (RESTART_VELOCITY)
		VELOCITY = EMITTER_VELOCITY;
	COLOR.rgb = vec3(0.6, 0.8, 2.5);
}

float getAngle(vec2 v)
{
	v = normalize(v);
	float a = atan(v.y, v.x);
	return a;
}

void process() {
	if (RESTART)
		CUSTOM.y = 0.0;
	
	vec3 position1 = getBezier(CUSTOM.y, points[0], points[1], points[2]);
	CUSTOM.y += DELTA / LIFETIME;
	vec3 position2 = getBezier(CUSTOM.y, points[0], points[1], points[2]);
	vec3 velocity = position2 - position1;
	
	TRANSFORM = getRotationY(getAngle(velocity.zx) + PI);
	vec2 pitch = vec2(length(velocity.xz), velocity.y);
	TRANSFORM *= getRotationX(getAngle(pitch));
	
	TRANSFORM[3].xyz += position2;
	
	if (CUSTOM.y < 1.0)
		COLOR.a = texture(alpha, vec2(CUSTOM.y)).r;
	else
		COLOR.a = 0.0;
}
