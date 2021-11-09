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


img1_title='stag1'
img2_title='stag2'

ext='.tiff' #'.png'

'''
img1 = imread('images/'+img1_title+'.png')
img2 = imread('images/'+img2_title+'.png')

'''
img1 = color.rgb2gray(color.rgba2rgb(imread('images/tiff/'+img1_title+ext)))
img2 = color.rgb2gray(color.rgba2rgb(imread('images/tiff/'+img2_title+ext)))

'''
# thresholding
img11=255*img1[:,:]/img1[:,:].max() 
img22=255*img2[:,:]/img2[:,:].max() 
# Conversion en 8-bit
img11=img11.astype(np.uint8)
img22=img22.astype(np.uint8)

img1 = cv2.GaussianBlur(img11,(1,1),0)
img2 = cv2.GaussianBlur(img22,(1,1),0)
'''
'''
_, img1= cv2.threshold(img11,0,255,cv2.THRESH_OTSU)
_, img2= cv2.threshold(img22,0,255,cv2.THRESH_OTSU)
'''

'''
figure()
subplot(121)
imshow(img1)
subplot(122)
imshow(img111)
'''
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
'''
px=32 # interrogation window size

vx=99*ones((int(floor(len(img1)/px)),int(floor(len(img1)/px))))
vy=99*ones((int(floor(len(img1)/px)),int(floor(len(img1)/px))))

ca=-1
for a in arange(0,len(img1),step=px):
    ca=ca+1
    cb=0
    for b in arange(0,len(img1),step=px):
        corr=scipy.signal.correlate(img1[a:a+px-1,b:b+px-1],img2[a:a+px-1,b:b+px-1],method='fft')    
        vert=where(corr==corr.max())[0][0]-floor(len(corr)/2)
        hor=where(corr==corr.max())[1][0]-floor(len(corr)/2)
        vx[ca,cb] = hor
        vy[ca,cb] = vert
        cb=cb+1

x=arange(0,len(img1),step=px)
y=arange(0,len(img1),step=px)

U=sqrt(pow(vx,2)+pow(vy,2))
figure()
streamplot(x,y,vx,vy,color='black',arrowsize=.5,linewidth=1)
contourf(x,y,U,cmap='coolwarm')
colorbar()
#quiver(x,y,vx,vy,color='black')
title('velocity field (contour + quiver)')
xlabel('x [px]')
ylabel('y [px]')

# still have to figure out how to correct direction
# of streamlines for unidirectional flows...
# probably has to do with matrix vs. image format
# and display







