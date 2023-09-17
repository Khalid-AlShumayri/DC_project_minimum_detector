## EE417_Project!

# Introduction
Quadrature amplitude modulation QAM combines the merits of amplitude and phase modulation (i.e., AM and PM). It increases the bandwidth efficiency by utilizing the amplitude and phase components to provide modulation. In this project, we simulated an 8-QAM signaling scheme in the presence of additive white-gaussian noise (AWGN) given the constellation diagram below. The simulated scheme was tested with different SNR values to observe the probability of error using minimum distance detector (MD) for signal decoding. In addition, the theortical error bounds were derived in and compared with the simulation results.

![Diagram](https://github.com/Khalid-AlShumayri/EE417_Project/assets/53300785/94f43122-3297-43bc-85d0-f783a9394694)



# The results

The picture below shows how the constellation diagram is divided based on the minimum distance detector in odrder to decode the received siganl.

![image](https://user-images.githubusercontent.com/53300785/206704441-a956ac99-545c-4420-ac0a-95130407e8b1.png)

Comparison between the theoretical and simulation symbol error rate (SER) and Bit error rate (BER). Immediate neighbour bound as will as union bound were derived for illustration. It can be noticed the immediate neighbour bound is more tight and provides a good approximation. 

![Result_SER_BER_1](https://github.com/Khalid-AlShumayri/EE417_Project/assets/53300785/6e4a3b8b-578e-4fb9-965c-e90276497623)
