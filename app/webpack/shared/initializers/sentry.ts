declare const ENVIRONMENT: string;
declare const RELEASE: string;
declare const SENTRY_DSN: string | null;

import * as Sentry from "@sentry/browser";

if (SENTRY_DSN && ENVIRONMENT !== "test" && ENVIRONMENT !== "development") {
  Sentry.init({
    dsn: SENTRY_DSN,
    environment: ENVIRONMENT,
    release: RELEASE,
  });
}
