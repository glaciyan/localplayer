export function addNoiseToCoordinates(
    latitude: number,
    longitude: number,
    noiseRadiusMeters: number
): { latitude: number; longitude: number } {
    // Convert noise radius from meters to degrees (approximate)
    const earthRadiusKm = 6371;
    const noiseRadiusKm = noiseRadiusMeters / 1000;

    // Generate random angle and distance
    const randomAngle = Math.random() * 2 * Math.PI;
    const randomDistance = Math.random() * noiseRadiusKm;

    // Calculate noise in degrees
    const latNoise =
        ((randomDistance * Math.cos(randomAngle)) / earthRadiusKm) *
        (180 / Math.PI);
    const lonNoise =
        (((randomDistance * Math.sin(randomAngle)) / earthRadiusKm) *
            (180 / Math.PI)) /
        Math.cos((latitude * Math.PI) / 180);

    return {
        latitude: latitude + latNoise,
        longitude: longitude + lonNoise,
    };
}
