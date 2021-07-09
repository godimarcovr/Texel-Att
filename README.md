# Texel-Att

This repository contains instruction to download *ElBa* dataset and it will soon contains code of Texel-Att framework.

Accepted and presented at BMVC 2019! [paper link](https://arxiv.org/abs/1908.11127).

## Texel-Att framework code


Code will be available soon!


![Texel-Att Texel-Att](/images/schema.png)

## Code

For the bounding boxes and masks extraction, please train one of the architectures available for ![MaskRCNN](https://pytorch.org/tutorials/intermediate/torchvision_tutorial.html)(we use the one with Resnet50 backbone) on ElBa dataset (the annotations are already in COCO format).

Once the detections are extracted, run the matlab code in the following order:
- computeAttributes.m
- computeAggregatePerClassAttribute.m

For the relative attributes' experiment, please use the official code published by the authors: https://www.cc.gatech.edu/~parikh/relative.html. 

## *ElBa* dataset


*ElBa* dataset is available to [download](https://drive.google.com/file/d/1YGmDjfz2S4dOLmz0nrjZOJbJuI4h58Rv).

Zip file contains the training and testing set images folders.

Boxes and masks annotations are provided in COCO format as json files. 

![ElBa ElBa](/images/elba.png)

## Citation

If you use Texel-Att or *Elba* dataset in your research or wish to refer to the results published in the [paper](https://arxiv.org/abs/1908.11127), please use the following BibTeX entry.

```
@article{godi2019texelatt,
  title={Texel-Att: Representing and Classifying Element-based Textures by Attributes},
  author={Godi, Marco and Joppi, Christian and Giachetti, Andrea and Pellacini, Fabio and Cristani, Marco},
  year={2019}
}
```

