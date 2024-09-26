/**
 * url-access-data types
 */

export type Platform = "android" | "ios";

export interface ParametersForHash {
  screenWidth: number;
  os: Platform;
  version: string;
  ip: string;
}