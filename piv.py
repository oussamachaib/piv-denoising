#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Nov  8 21:36:13 2021

@author: oussamachaib
"""

from pylab import*
import random
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

close('all')


img1_title='rankine1'
img2_title='rankine2'

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

px=32 # interrogation window size
dt = 1
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
        vx[ca,cb] = -hor/dt
        vy[ca,cb] = -vert/dt
        cb=cb+1

xv=arange(px/2,len(img1),step=px)
yv=arange(px/2,len(img1),step=px)

x=linspace(0,len(img1)+1,int(px/2))
y=linspace(0,len(img1)+1,int(px/2))

U=sqrt(pow(vx,2)+pow(vy,2))
U=U/U.max()
figure()
#streamplot(x,y,-vx,-vy,color='black',arrowsize=.5,linewidth=1)
contourf(x,y,U,cmap='coolwarm')
colorbar(label='Normalized velocity Û [-]')
quiver(xv,yv,vx,vy,color='black')
title('velocity field ('+img1_title+', '+img2_title+')')
xlabel('x [px]')
ylabel('y [px]')
#plt.gca().invert_xaxis()
xlim(0,512)
ylim(0,512)
'''
vfield = plt.gca()
vfield.axes.xaxis.set_visible(False)
vfield.axes.yaxis.set_visible(False)
'''
#savefig('figures/vfield-'+img1_title+'-'+img2_title+'.png',dpi=600)
# still have to figure out how to correct direction
# of streamlines for unidirectional flows...
# probably has to do with matrix vs. image format
# and display







