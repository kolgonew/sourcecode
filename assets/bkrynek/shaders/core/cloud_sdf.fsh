#version 150

// SDF GUI shader - fragment stage.
//
// Jeden QUAD = jeden zaokraglony prostokat (opcjonalnie kolo, gdy radius = min(w,h)/2).
// Wszystko liczone jest per piksel z pola odleglosci (signed distance field):
//   * zaokraglone rogi i krawedzie - gladkie, antyaliasowane przez fwidth() (dokladnie 1 px),
//   * obrys (border) o dowolnej grubosci, bez rozjezdzania sie na rogach,
//   * miekki cien / poswiata (softness) rozkladane po SDF, a nie "stos prostokatow",
//   * gradient pionowy: kolor wypelnienia interpolowany jest z wierzcholkow (atrybut Color),
//     a pasma gradientu wielostopniowego sklada Java jako kilka QUAD-ow (patrz SdfShapes).
//
// Uniformy (kazdy MUSI byc zadeklarowany w sdf_rect.json, inaczej getUniform() zwroci null):
//   RectSize    - polowa rozmiaru prostokata (w,h)/2 w jednostkach logicznych GUI
//   Params      - (radius, borderWidth, softness, glowOffset)
//   BorderColor - kolor obrysu (straight alpha)
//   ShadowColor - kolor cienia/poswiaty (straight alpha)
//
// Wyjscie jest PREMULTIPLIED (rgb * a), bo takie jest tez blending w SdfShapes:
// blendFuncSeparate(ONE, ONE_MINUS_SRC_ALPHA, ONE, ONE_MINUS_SRC_ALPHA).

uniform vec2 RectSize;
uniform vec4 Params;
uniform vec4 BorderColor;
uniform vec4 ShadowColor;
uniform vec4 ColorModulator;

in vec2 vLocal;
in vec4 vColor;

out vec4 fragColor;

// Odleglosc ze znakiem od zaokraglonego prostokata o polowach bokow b i promieniu r.
// Ujemna w srodku, 0 na krawedzi, dodatnia na zewnatrz.
float sdRoundBox(vec2 p, vec2 b, float r) {
    vec2 q = abs(p) - b + vec2(r);
    return min(max(q.x, q.y), 0.0) + length(max(q, vec2(0.0))) - r;
}

void main() {
    vec2 halfSize = max(RectSize, vec2(0.0));
    float limit = min(halfSize.x, halfSize.y);

    float r  = clamp(Params.x, 0.0, limit);
    float bw = clamp(Params.y, 0.0, limit);
    // softness == 0 musi zostac bezpieczne dla smoothstep (dzielenie przez zero -> NaN).
    float soft = max(Params.z, 0.001);

    // Szerokosc paska AA: zmiana pozycji lokalnej na piksel ekranu (fwidth), min. 1/1000.
    float aa = max(max(fwidth(vLocal.x), fwidth(vLocal.y)), 0.0001);

    // --- ksztalt zewnetrzny i wewnetrzny ---
    float d = sdRoundBox(vLocal, halfSize, r);
    float outerA = 1.0 - smoothstep(-0.5 * aa, 0.5 * aa, d);

    float innerA = 0.0;
    if (bw > 0.0) {
        float dIn = sdRoundBox(vLocal, halfSize - vec2(bw), max(r - bw, 0.0));
        innerA = 1.0 - smoothstep(-0.5 * aa, 0.5 * aa, dIn);
    }

    // --- cien / poswiata: wykladniczo wygaszana odleglosc na zewnatrz ksztaltu ---
    float ds = d - Params.w;
    // Gaussian edge integral; CSS blur radius corresponds to 2 sigma.
    float z = ds / max(soft * 0.5, 0.001);
    float glowA = (1.0 / (1.0 + exp(1.702 * z))) * ShadowColor.a;

    // Wypelnienie pokrywa CALY ksztalt (jak background w CSS), a obrys jest pierscieniem
    // (outerA - innerA) kladzionym NA WIERZCHU - dzieki temu przy borderWidth = 0 nic nie znika,
    // a polprzezroczysty obrys widac razem z wypelnieniem pod nim.
    float fillA   = vColor.a * outerA;
    float borderA = BorderColor.a * max(outerA - innerA, 0.0);

    // --- kompozycja "over" w przestrzeni premultiplied: poswiata -> wypelnienie -> obrys ---
    vec3 rgb = ShadowColor.rgb * glowA;
    float a = glowA;

    rgb = vColor.rgb * fillA + rgb * (1.0 - fillA);
    a = fillA + a * (1.0 - fillA);

    rgb = BorderColor.rgb * borderA + rgb * (1.0 - borderA);
    a = borderA + a * (1.0 - borderA);

    if (a <= 0.0) {
        discard;
    }

    fragColor = vec4(rgb, a) * ColorModulator;
}
