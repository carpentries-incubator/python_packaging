from .models import SIR_model, SEIR_model, SIS_model
from .plotting import plot_SIR_model, plot_SEIR_model, plot_SIS_model

__version__ = "1.2.3"

# Deliberately leaving SIS_model out of __all__
__all__ = ["SIR_model", "SEIR_model"]
