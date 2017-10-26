from django.contrib.gis.db.models import PointField
from django.db import models

DEFAULT_SRID= 4326

class Location(models.Model):
    point = PointField(srid=DEFAULT_SRID, null=True, blank=True)
