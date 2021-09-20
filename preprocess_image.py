import os
import sys

import cv2
import numpy as np

filepath = sys.argv[1]
filename = os.path.basename(filepath)
img = cv2.imread(filepath, 0)

# Dirty style postprocessing
img = np.where(img >= 240, 255, img)
# img = np.where(img < 240, 0, img)
img = np.where((img > 200) & (img < 240), 0, img)

# Save new image
cv2.imwrite(os.path.join('processed', filename), img)
print('Image processed')
