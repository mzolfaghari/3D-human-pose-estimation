%====================================================================

This code is for our Machine Vision and Applications 2014 paper:

	
<strong>“3D Human Pose Estimation from Image using Couple Sparse Coding”</strong>

This work is created by Mohammadreza Zolfaghari, Amin Jourabloo, S. Ghareh Gozlou, Bahmand Pedrood, M.T. Manzuri-Shalmani from Sharif University of Technology, Michigan State University and Amirkabir University of Technology.

<h3>Citing this work:</h3>

If you are using this code for your research, please cite the following paper:<br>



<pre><code>@article{MZolfaghariMVA14, <br>
  author    = {Mohammadreza Zolfaghari and <br>
               Amin Jourabloo and <br>
               Samira Ghareh Gozlou and <br>
               Bahman Pedrood and <br>
               Mohammad T. Manzuri Shalmani},
  title     = {3D human pose estimation from image using couple sparse coding},
  journal   = {Mach. Vis. Appl.},
  volume    = {25},
  number    = {6},
  pages     = {1489--1499},
  year      = {2014},
  url       = {http://dx.doi.org/10.1007/s00138-014-0613-6},
  doi       = {10.1007/s00138-014-0613-6},
  timestamp = {Tue, 15 Jul 2014 01:00:00 +0200},
  biburl    = {http://dblp.uni-trier.de/rec/bib/journals/mva/ZolfaghariJGPS14},
  bibsource = {dblp computer science bibliography, http://dblp.org}
}
</code></pre>
<br>
<h3>Copyright:</h3>
Mohammadreza Zolfaghari (Sharif University of Technology), Amin Jourabloo (Michigan State University).

<strong>Contact:</strong>  mzolfaghari@ce.sharif.edu; jourablo@msu.edu 



Download source code from https://github.com/mzolfaghari/3DPoseUsingCoupleSparseCoding 

<p>

<h3>Database:</h3>
In the paper, We tested the performance of the proposed method on CMU Mocap database which consists of different activities such as acrobatic, navigate, throw and catch football, golf, laugh, Michael Jackson styled motions, run and kick soccer ball. It is available online at http://mocap.cs.cmu.edu. In all the experiments, we used this dataset in BVH format to create synthesized poses rendered from real motion captured data by POSER

Please find it in https://github.com/mzolfaghari/3DPoseUsingCoupleSparseCoding/Database
<ul class="task-list">

<h3>Usage:</h3>
<li> X (100-D) correspond to the Histogram of Shape Context features extracted from images </li>
<li> Y (60-D) correspond to 3D pose of images.</li>
</ul>
<ul class="task-list">
<li>Run.m is the main function to reproduce the results in the paper.</li>
<li>To generate 3D human shapes you need produce BVH formats of each video sequence.
In this code, we provide Demo.m which produces BVH formats for estimated poses. Then you can import generated BVHs into any proper software like POSER (available at http://www.poser.com) to generate 3D human shapes.</li>

<br>
 In 'Help_ImportBVH_POSER.png' you can find how to import BVH into POSER
 software

<br>
Please refer to renderbody_example function in the MocapRoutines folder to
find more methods in rendering your 3D Human models provided by Ankur
Agarwal in "Recovering 3D Human Pose from Monocular Images", PAMI, 2005

</ul>

<br>

If you have any question about paper or issues running the codes, please contact:

 Mohammadreza Zolfaghari (mzolfaghari@ce.sharif.edu).


Thanks.


Mohammadreza Zolfaghari
