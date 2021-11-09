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

close('all')
start=time.time()

img1_title='piv-synth1'
img2_title='piv-synth2'

img1 = color.rgb2gray(color.rgba2rgb(imread('images/'+img1_title+'.png')))
img2 = color.rgb2gray(color.rgba2rgb(imread('images/'+img2_title+'.png')))
'''
figure(1)
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
px=40 # interrogation window size
span=arange(0,int(len(img1)),step=px)
vx=1337*ones((len(span),len(span)))
vy=1337*ones((len(span),len(span)))
cntb=-1
for b in span:
    cntb=cntb+1
    cnta=0
    for a in span:
        corr=scipy.signal.correlate(img1[b:b+px,a:a+px],img2[b:b+px,a:a+px],method='fft')
        #end=time.time()
        #tm=end-start
        #print(f'Time elapsed: {tm:.2} seconds')
        '''
        figure(2)
        subplot(121)
        title(f'img1[{b}:{a},{b}:{a}]')
        xlabel('x [px]')
        ylabel('y [px]')
        imshow(img1[b:a,b:a],'gray')
        subplot(122)
        imshow(img2[b:a,b:a],'gray')
        title(f'img2[{b}:{a},{b}:{a}]')
        xlabel('x [px]')
        ylabel('y [px]')
        '''
        '''
        figure(3)
        ax=axes()
        '''
        
        x=linspace(1,len(corr)+1)#,num=len(corr))
        y=linspace(1,len(corr)+1)#,num=len(corr))
        
        X,Y = meshgrid(x,y)
        #ax = plt.axes(projection='3d')
        #ax.plot_surface(X,Y,corr,cmap='hot')
        #ax.set_title(f'corr(img1[{b}:{a},{b}:{a}],img2[{b}:{a},{b}:{a}])')
        #ax.set_xlabel('x [px]')
        #ax.set_ylabel('y [px]')
        #ax.set_zlabel('corr')
        #print(where(corr==corr.max()))
        dy=where(corr==corr.max())[1][0]-round(mean(y))
        dx=where(corr==corr.max())[0][0]-round(mean(x))
        #print(f'Displacement: {dy:.2} - {dx:.2}')
        vy[cntb,cnta]=dx
        vx[cntb,cnta]=dy
        cnta=cnta+1
vx=vx/vx.max()
vy=vy/vx.max()

figure()
quiver(vx[1:-1,1:-1],vy[1:-1,1:-1])
