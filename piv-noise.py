#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Nov 12 10:27:54 2021

@author: oussamachaib
"""

from pylab import*
import random
import scipy.signal
from scipy.stats import truncnorm
import cv2 as cv2
import pywt
from skimage import color
from skimage import io
from mpl_toolkits import mplot3d
import time

import warnings
import matplotlib.cbook
warnings.filterwarnings("ignore",category=matplotlib.cbook.mplDeprecation)
import scripts as sc



close('all')



img1_title='rankine1'
img2_title='rankine2'

ext='.tiff'
    
img1 = color.rgb2gray(color.rgba2rgb(imread('images/tiff/'+img1_title+ext)))
img2 = color.rgb2gray(color.rgba2rgb(imread('images/tiff/'+img2_title+ext)))

np.random.seed(99)

gaussian_noise=sc.ndist(mean=0,std=.1,low=0,up=1)
noise = gaussian_noise.rvs(size(img1))
noise_reshaped = reshape(noise,(len(img1),len(img1)))
img1n=img1+noise_reshaped
img2n=img2+noise_reshaped

figure()
subplot(121)
imshow(img1[400:500,0:100],'gray')
title('img1')
subplot(122)
imshow(img1n[400:500,0:100],'gray')
title('img1 + noise')
'''
subplot(223)
imshow(img2,'gray')
title('img2')
subplot(224)
imshow(img2n,'gray')
title('img2 + noise')
#colorbar()
'''
tight_layout()

img1=img1n
img2=img2n

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
print(r'U_max = '+str(U.max()))
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
















