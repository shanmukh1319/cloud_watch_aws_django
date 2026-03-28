import logging
import os
import threading
import time

from django.apps import AppConfig

log = logging.getLogger("django.continuous")


def _django_heartbeat_loop():
    n = 0
    while True:
        n += 1
        log.info(
            "Django heartbeat #%s — continuous log line for CloudWatch (django process)",
            n,
        )
        time.sleep(6)


class CoreConfig(AppConfig):
    default_auto_field = "django.db.models.BigAutoField"
    name = "core"

    def ready(self):
        # Avoid duplicate threads from the autoreloader parent process.
        if os.environ.get("RUN_MAIN") != "true":
            return
        if os.environ.get("DISABLE_DJANGO_HEARTBEAT") == "1":
            return
        t = threading.Thread(target=_django_heartbeat_loop, daemon=True, name="django-log-heartbeat")
        t.start()
