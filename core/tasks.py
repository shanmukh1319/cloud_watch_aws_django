import logging

from celery import shared_task

log = logging.getLogger("celery.heartbeat")


@shared_task
def emit_celery_heartbeat():
    log.info(
        "Celery beat task — continuous log line for CloudWatch (celery worker process)"
    )
