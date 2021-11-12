#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Fri Nov 12 10:42:20 2021

@author: oussamachaib
"""
from pylab import*
from scipy.stats import truncnorm
import cv2 as cv2


def ndist(mean, std, low, up):
    return truncnorm(
        (low - mean) / std, (up - mean) / std, loc=mean, scale=std
        )






