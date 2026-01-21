import Live # type: ignore
from .FC200 import FC200

def create_instance(c_instance):
    ' Creates and returns the APC20 script '
    return FC200(c_instance)


# local variables:
# tab-width: 4
