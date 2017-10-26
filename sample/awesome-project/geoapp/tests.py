import logging
from django.contrib.gis.geos import Point
from django.test import TestCase
from django.contrib.gis.db.models import functions
from django.contrib.gis.measure import Distance

from . import models

logging.basicConfig(format='%(asctime)s %(levelname)-7s %(thread)-5d %(filename)s:%(lineno)s | %(funcName)s | %(message)s', datefmt='%H:%M:%S')
logging.getLogger().setLevel(logging.DEBUG)
logging.disable(logging.NOTSET)
logging.getLogger('environ').setLevel(logging.INFO)


class GeoTests(TestCase):
    def test_distance(self):
        location_manager = models.Location.objects
        location_manager.create(point=Point(x=float(-119), y=float(35), srid=models.DEFAULT_SRID))
        item = location_manager.create(point=Point(x=float(-118), y=float(34), srid=models.DEFAULT_SRID))
        queryset = location_manager.all()

        point = Point(x=float(-119), y=float(34), srid=models.DEFAULT_SRID)
        distance = Distance(km=100)

        queryset = queryset.filter(point__distance_lte=(point, distance))
        queryset = queryset.annotate(distance=functions.Distance('point', point))

        logging.debug("queryset[0].distance: %s", queryset[0].distance)
        self.assertEqual(Distance(m=92184.53310623), queryset[0].distance)
        self.assertEqual([item], list(queryset))

