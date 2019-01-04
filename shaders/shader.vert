#version 310 es
precision mediump float;
layout(location = 0) in vec2 a_particlePos;
layout(location = 1) in float a_particleDen;
layout(location = 2) in vec2 a_particleVel;
layout(location = 3) in vec2 a_pos;
uniform mat4 u_viewProjection;
out vec2 xsv_POSITION0;
out vec4 COLOR0;

struct Particle
{
    vec2 position;
    vec2 velocity;
};

struct ParticleDensity
{
    float density;
};

layout(std140, binding = 0) buffer ParticlesRO
{
    readonly Particle particles[${g_iNumParticles}];
} particlesRO;

layout(std140, binding = 1) buffer ParticleDensityRO
{
    readonly ParticleDensity particles[${g_iNumParticles}];
} particleDensityRO;

vec4 Rainbow[5] = vec4[5](vec4(1, 0, 0, 1), vec4(1, 1, 0, 1), vec4(0, 1, 0, 1), vec4(0, 1, 1, 1), vec4(0, 0, 1, 1));

vec4 VisualizeNumber(float n)
{
    return mix(Rainbow[uint(floor(n * 4.0f))], Rainbow[uint(ceil(n * 4.0f))], vec4(fract(n * 4.0f)));
}

vec4 VisualizeNumber(float n, float lower, float upper)
{
    return VisualizeNumber(clamp((n - lower) / (upper - lower), float(0), float(1)));
}

void main()
{
    xsv_POSITION0 = particlesRO.particles[gl_VertexID].position;
    COLOR0 = VisualizeNumber(particleDensityRO.particles[gl_VertexID].density, 1000.0f, 2000.0f);
    COLOR0 = VisualizeNumber(a_particleDen, 1000.0f, 2000.0f);
    //float angle = -atan(a_particleVel.x, a_particleVel.y);
    //vec2 pos = vec2(a_pos.x * cos(angle) - a_pos.y * sin(angle),
//a_pos.x * sin(angle) + a_pos.y * cos(angle));
    gl_Position = vec4(a_particlePos, 0.0, 1.0);
    //gl_Position = (u_viewProjection * vec4(a_particlePos, 0.0, 1.0));
    //gl_Position = (mat4(0,0,0,0,0,0,0,0,0.8,0.6,-1,-1,0,0,0,0) * vec4(a_particlePos, 0.0, 1.0));
    //gl_Position = (mat4(0.8,0.6,0,0,0,0,0,0,0,0,0,0,-1,-1,0,1) * vec4(a_particlePos, 0.0, 1.0));
    //gl_Position = (vec4(a_particlePos, 0.0, 1.0) * u_viewProjection);
    gl_PointSize = 4.0;
}

