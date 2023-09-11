declare const ENVIRONMENT: string;
declare const RELEASE: string;
declare const SENTRY_DSN: string | null;
declare const SENTRY_TRACES_SAMPLE_RATE: number | null;

import * as Sentry from "@sentry/browser";
import { BrowserTracing } from "@sentry/browser";

if (SENTRY_DSN && ENVIRONMENT === "production") {
  Sentry.init({
    dsn: SENTRY_DSN,
    environment: ENVIRONMENT,
    release: RELEASE,
    integrations: [new BrowserTracing()],
    tracesSampleRate: SENTRY_TRACES_SAMPLE_RATE ?? undefined,
  });
}
