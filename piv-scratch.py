#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Nov  8 21:36:13 2021

@author: oussamachaib
"""

from pylab import*
import scipy.signal
import cv2 as cv2
import pywt
from skimage import color
from skimage import io
from mpl_toolkits import mplot3d
import time

import warnings
import matplotlib.cbook
warnings.filterwarnings("ignore",category=matplotlib.cbook.mplDeprecation)

'''
from PIL import Image
I = img2[1:,1:]
I8 = (((I - I.min()) / (I.max() - I.min())) * 255.9).astype(np.uint8)

img = Image.fromarray(I8)
img.save("piv2.png")
'''

close('all')


img1_title='piv1'
img2_title='piv2'

img1 = imread('images/'+img1_title+'.png')
img2 = imread('images/'+img2_title+'.png')
'''
img1_title='piv-synth1'
img2_title='piv-synth2'

img1 = color.rgb2gray(color.rgba2rgb(imread('images/'+img1_title+'.png')))
img2 = color.rgb2gray(color.rgba2rgb(imread('images/'+img2_title+'.png')))
'''

# # thresholding
# img11=255*img1[:,:]/img1[:,:].max() 
# img22=255*img2[:,:]/img2[:,:].max() 
# # Conversion en 8-bit
# img11=img11.astype(np.uint8)
# img22=img22.astype(np.uint8)
# _, img1= cv2.threshold(img11,0,255,cv2.THRESH_OTSU)
# _, img2= cv2.threshold(img22,0,255,cv2.THRESH_OTSU)
'''
figure()
subplot(121)
imshow(img1)
subplot(122)
imshow(img111)
'''

figure()
ax0=subplot(121)
title('img1')
ax0.set_xlabel('x [px]')
ax0.set_ylabel('y [px]')
ax0.imshow(img1,'gray')
ax1=subplot(122)
ax1.imshow(img2,'gray')
title('img2')
ax1.set_xlabel('x [px]')
ax1.set_ylabel('y [px]')

px=24 # interrogation window size
corr_std=scipy.signal.correlate(img1[0:px-1,24:24+px-1],img1[0:px-1,24:24+px-1],method='fft')    
corr=scipy.signal.correlate(img1[0:px-1,24:24+px-1],img2[0:px-1,24:24+px-1],method='fft')    
vert=where(corr==corr.max())[0][0]-floor(len(corr)/2)
hor=where(corr==corr.max())[1][0]-floor(len(corr)/2)
vx = hor
vy = vert
i=where(corr_std==corr_std.max())[0][0] # y-axis
j=where(corr_std==corr_std.max())[1][0] # x-axis
k=where(corr==corr.max())[0][0]
l=where(corr==corr.max())[1][0]

u = j-l
v = i-k

figure()
subplot(121)
title('default')
imshow(corr_std)
scatter(j,i,color='red')
subplot(122)
imshow(corr)
scatter(l,k,color='red')
title('current')


