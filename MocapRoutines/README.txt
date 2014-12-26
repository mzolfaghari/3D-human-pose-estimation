
What one can do with routines in this directory:

* read files in amc format into matlab (only tested for those from the cmu mocap
  database http://mocap.cs.cmu.edu/) 
  - amc_to_3dmatrix.m & amc_to_matrix.m

* see what the various parameters in my reduced representation from
  the cmu acclaim mocap format are: 
  - amc_format.txt

* convert from amc to gregory shaknorovich's format (used in psh paper
  in iccv03') and vice versa. amc here is referred to as my "spring"
  format as thats what is used to render the green mr. spring who
  appears in my papers.
  - shak2spring.m and spring2shak.m
 
* read some particular bvh files that were carefully transformed to be
  compatible with poser. these are available in bvh_examples/
  - bvh_to_2dmatrix.m, bvh_to_3dmatrix.m, bvh_to_matrix.m 

* see the parameters meaings in the bvh reprsentation
  - bvh_format.txt 

* convert any euler angle triplet (rx,ry,rz) or tuple (rx,rz) into a
  corresponding triplet (rx',ry',rz') or tuple (rx',rz') that gives
  the same net rotation but is free from gimbal locks. (do this for
  each triplet of the entire body separately to degimbal a
  represntation of the entire body)
   - degimbal.m

* render the green spring man for files in bvh or amc format, or an
  appropriate matrix. 
  - renderbody.m (this uses several other files present in the
  directory)
  Note this routine has several options to produce a "blob man",
  "stick man", "spring man" etc and can be used to simply view images
  (press any key to move to next frame)
  and animate them or to dump images and create movies (creating
  movies using matlab is not recommended -- much better to dump images
  and use mencoder or something). also can produce binary masks
  (silhouettes). most of these options are supported through arguments that go
  into the function call but much more can be achieved by changing
  pieces of code here and there. if you want to do something with this
  routine and there are no suitable options, chances are u will just
  have to comment out some lines and uncomment others. if things are not
  clear, u might want to ask me if i have already done it before
  trying to write new code.
  (Try renderbody_example.m to start with)




* Suggested readings: 
- ACCLAIM: http://www.cs.wisc.edu/graphics/Courses/cs-838-1999/Jeff/ASF-AMC.html
- BVH: http://www.cs.wisc.edu/graphics/Courses/cs-838-1999/Jeff/BVH.html
- GIMBAL LOCKS: http://www.anticz.com/eularqua.htm
- DIFFERENT REPRESENTATIONS: appendix 2 of my phd thesis (also
  contains some info about how the matlab rendering routine works)

* Other possibly interesting information about mocap:
- http://www.okino.com/conv/exp_bvh.htm
- http://www-static.cc.gatech.edu/classes/AY2005/cs4496_fall/PS/ps2F.htm

* Sources of mocap data:
- http://acabar.cafwap.net/~zier/anim/
- http://gl.ict.usc.edu/animWeb/humanoid/
- http://mocap.cs.cmu.edu/search.php?subjectnumber=%25&motion=%25




- Ankur Agarwal
  02/05/2006