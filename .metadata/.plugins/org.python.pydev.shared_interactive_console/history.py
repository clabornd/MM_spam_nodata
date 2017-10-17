import sys; print('%s %s' % (sys.executable or sys.platform, sys.version))
import pandas as pd
import pickle
import os
data_loc = os.path.dirname(__file__)+"/new_emails.csv"
