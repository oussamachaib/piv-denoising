#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Nov  5 14:10:13 2021

@author: oussamachaib
"""

from pylab import*
import cv2 as cv2
import pywt
from skimage import color
from skimage import io

close('all')

original = imread('images/piv-synth1.png')
original = color.rgb2gray(color.rgba2rgb(original))

#imshow(original,'gray')

coeffs2 = pywt.dwt2(original, 'db1')
ll, (lh, hl, hh) = coeffs2

fig = plt.figure(figsize=(12, 3))
for i, a in enumerate([ll, lh, hl, hh]):
    ax = fig.add_subplot(1, 4, i + 1)
    ax.imshow(a, interpolation="nearest", cmap=plt.cm.gray)
    ax.set_xticks([])
    ax.set_yticks([])

fig.tight_layout()
plt.show()