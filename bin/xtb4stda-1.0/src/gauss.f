! This file is part of xtb4stda.
!
! Copyright (C) 2015-2019 Stefan Grimme
!
! xtb4stda is free software: you can redistribute it and/or modify it under
! the terms of the GNU Lesser General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! xtb4stda is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU Lesser General Public License for more details.
!
! You should have received a copy of the GNU Lesser General Public License
! along with xtb4stda.  If not, see <https://www.gnu.org/licenses/>.

c STO-nG BY R.F. STEWART, J. CHEM. PHYS., 52 431-438, 1970

c nprim: returned # of primitives
c n: principal QN, input
c l: angular QN (1=s, 2=p, ...), input
c zeta: Slater exponent, input
c expo: Gaussian exponents (out)
c cont: Gaussian contraction coefficients (out)

c STO-nG BY R.F. STEWART, J. CHEM. PHYS., 52 431-438, 1970

c nprim: returned # of primitives
c n: principal QN, input
c l: angular QN (1=s, 2=p, ...), input
c zeta: Slater exponent, input
c expo: Gaussian exponents (out)
c cont: Gaussian contraction coefficients (out)

      SUBROUTINE SETSTO1(nprim,n,l,zeta,expo,cont)
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      dimension expo(*),cont(*)
      dimension ALLC(2,6,3),ALLZ(2,6,3)
      integer iam,nprim
      real*8 DEX(-1:96)

      nprim=1

      PI=4.D0*ATAN(1.D0)
      DO I=-1,10
         DEX(I)=DEX2(I)
      ENDDO
c 1s
      ALLZ(1,1,1)=0.2709498091
      ALLC(1,1,1)=1.0d0
c 2s
      ALLZ(1,2,1)=0.1012151084
      ALLC(1,2,1)=1.0d0
c 2p
      ALLZ(1,2,2)=0.1759666885
      ALLC(1,2,2)=1.0d0

      iam=l-1
      DO J=1,nprim
         cont(J)=ALLC(J,N,L)
         expo(J)=ALLZ(J,N,L)*zeta**2
         XNORM=(2.D0*EXPO(J)/PI)**0.75D0*(4.D0*EXPO(J))**(IAM/2.D0)/
     .          SQRT(DEX(2*IAM-1))
         cont(j)=cont(j)*xnorm
      ENDDO

      end

      SUBROUTINE SETSTO2(nprim,n,l,zeta,expo,cont)
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      dimension expo(*),cont(*)
      dimension ALLC(2,6,3),ALLZ(2,6,3)
      integer iam,nprim
      real*8 DEX(-1:96)

      nprim=2

      PI=4.D0*ATAN(1.D0)
      DO I=-1,10
         DEX(I)=DEX2(I)
      ENDDO
c 1s
      ALLZ(1,1,1)=8.518186635D-1
      ALLZ(2,1,1)=1.516232927D-1
      ALLC(1,1,1)=4.301284983D-1
      ALLC(2,1,1)=6.789135305D-1
c 2s
      ALLZ(1,2,1)=1.292278611D-1
      ALLZ(2,2,1)=4.908584205D-2
      ALLC(1,2,1)=7.470867124D-1
      ALLC(2,2,1)=2.855980556D-1
c 2p
      ALLZ(1,2,2)=4.323908358D-1
      ALLZ(2,2,2)=1.069139065D-1
      ALLC(1,2,2)=4.522627513D-1
      ALLC(2,2,2)=6.713122642D-1

      iam=l-1
      DO J=1,nprim
         cont(J)=ALLC(J,N,L)
         expo(J)=ALLZ(J,N,L)*zeta**2
         XNORM=(2.D0*EXPO(J)/PI)**0.75D0*(4.D0*EXPO(J))**(IAM/2.D0)/
     .          SQRT(DEX(2*IAM-1))
         cont(j)=cont(j)*xnorm
      ENDDO

      end

      SUBROUTINE SETSTO3(nprim,n,l,zeta,expo,cont)
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      dimension expo(*),cont(*)
      dimension ALLC(3,5,3),ALLZ(3,5,3)
      integer iam,nprim
      real*8 DEX(-1:96)

      nprim=3

      PI=4.D0*ATAN(1.D0)
      DO I=-1,10
         DEX(I)=DEX2(I)
      ENDDO

      ALLZ(1,1,1) =2.227660584D00
      ALLZ(2,1,1) =4.057711562D-01
      ALLZ(3,1,1) =1.098175104D-01
      ALLC(1,1,1) =1.543289673D-01
      ALLC(2,1,1) =5.353281423D-01
      ALLC(3,1,1) =4.446345422D-01
C                                      2S
      ALLZ(1,2,1) =2.581578398D00
      ALLZ(2,2,1) =1.567622104D-01
      ALLZ(3,2,1) =6.018332272D-02
      ALLC(1,2,1) =-5.994474934D-02
      ALLC(2,2,1) =5.960385398D-01
      ALLC(3,2,1) =4.581786291D-01
C                                     2P
      ALLZ(1,2,2) =9.192379002D-01
      ALLZ(2,2,2) =2.359194503D-01
      ALLZ(3,2,2) =8.009805746D-02
      ALLC(1,2,2) =1.623948553D-01
      ALLC(2,2,2) =5.661708862D-01
      ALLC(3,2,2) =4.223071752D-01
C                                      3S
      ALLZ(1,3,1) =5.641487709D-01
      ALLZ(2,3,1) =6.924421391D-02
      ALLZ(3,3,1) =3.269529097D-02
      ALLC(1,3,1) =-1.782577972D-01
      ALLC(2,3,1) =8.612761663D-01
      ALLC(3,3,1) =2.261841969D-01
C                                     3P
      ALLZ(1,3,2) =2.692880368D00
      ALLZ(2,3,2) =1.489359592D-01
      ALLZ(3,3,2) =5.739585040D-02
      ALLC(1,3,2) =-1.061945788D-02
      ALLC(2,3,2) =5.218564264D-01
      ALLC(3,3,2) =5.450015143D-01
C                                      4S
      ALLZ(1,4,1) =2.267938753D-01
      ALLZ(2,4,1) =4.448178019D-02
      ALLZ(3,4,1) =2.195294664D-02
      ALLC(1,4,1) =-3.349048323D-01
      ALLC(2,4,1) =1.056744667D00
      ALLC(3,4,1) =1.256661680D-01
C                                     4P
      ALLZ(1,4,2) =4.859692220D-01
      ALLZ(2,4,2) =7.430216918D-02
      ALLZ(3,4,2) =3.653340923D-02
      ALLC(1,4,2) =-6.147823411D-02
      ALLC(2,4,2) =6.604172234D-01
      ALLC(3,4,2) =3.932639495D-01
C                                      5S
      ALLZ(1,5,1) =1.080198458D-01
      ALLZ(2,5,1) =4.408119382D-02
      ALLZ(3,5,1) =2.610811810D-02
      ALLC(1,5,1) =-6.617401158D-01
      ALLC(2,5,1) =7.467595004D-01
      ALLC(3,5,1) =7.146490945D-01
C                                     5P
      ALLZ(1,5,2) =2.127482317D-01
      ALLZ(2,5,2) =4.729648620D-02
      ALLZ(3,5,2) =2.604865324D-02
      ALLC(1,5,2) =-1.389529695D-01
      ALLC(2,5,2) =8.076691064D-01
      ALLC(3,5,2) =2.726029342D-01

c 3d
      ALLZ(1,3,3) =5.229112225D-1
      ALLZ(2,3,3) =1.639595876D-1
      ALLZ(3,3,3) =6.386630021D-2
      ALLC(1,3,3) =1.686596060D-1
      ALLC(2,3,3) =5.847984817D-1
      ALLC(3,3,3) =4.056779520D-1

c 4d
      ALLZ(1,4,3) =1.777717219D-1
      ALLZ(2,4,3) =8.040647350D-2
      ALLZ(3,4,3) =3.949855551D-2
      ALLC(1,4,3) =2.308552718D-1
      ALLC(2,4,3) =6.042409177D-1
      ALLC(3,4,3) =2.595768926D-1
c 5d
      ALLZ(1,5,3) =4.913352950D-1
      ALLZ(2,5,3) =7.329090601D-2
      ALLZ(3,5,3) =3.594209290D-2
      ALLC(1,5,3) =-2.010175008D-2
      ALLC(2,5,3) =5.899370608D-1
      ALLC(3,5,3) =4.658445960D-1

      iam=l-1
      DO J=1,nprim
         cont(J)=ALLC(J,N,L)
         expo(J)=ALLZ(J,N,L)*zeta**2
         XNORM=(2.D0*EXPO(J)/PI)**0.75D0*(4.D0*EXPO(J))**(IAM/2.D0)/
     .          SQRT(DEX(2*IAM-1))
         cont(j)=cont(j)*xnorm
      ENDDO

      END

      DOUBLE PRECISION FUNCTION DEX2(M)
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      IF(M .LT. 2) THEN
         DEX2=1
      ELSE
         DEX2=1
         DO 10 I=1,M,2
   10    DEX2=DEX2*I
      ENDIF
      RETURN
      END

      SUBROUTINE SETSTO4(nprim,n,l,zeta,expo,cont)
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      dimension expo(*),cont(*)
      dimension ALLC(4,5,4),ALLZ(4,5,4)
      integer iam,nprim
      real*8 DEX(-1:96)

      nprim=4

      PI=4.D0*ATAN(1.D0)
      DO I=-1,10
         DEX(I)=DEX2(I)
      ENDDO
C                      1S
      ALLZ(1,1,1) =5.216844534
      ALLZ(2,1,1) =9.546182760D-1
      ALLZ(3,1,1) =2.652034102D-1
      ALLZ(4,1,1) =8.801862774D-2
      ALLC(1,1,1) =5.675242080D-2
      ALLC(2,1,1) =2.601413550D-1
      ALLC(3,1,1) =5.328461143D-1
      ALLC(4,1,1) =2.916254405D-1
C                      2S
      ALLZ(1,2,1) =1.161525551D1
      ALLZ(2,2,1) =2.000243111
      ALLZ(3,2,1) =1.607280687D-1
      ALLZ(4,2,1) =6.125744532D-2
      ALLC(1,2,1) =-1.198411747D-2
      ALLC(2,2,1) =-5.472052539D-2
      ALLC(3,2,1) =5.805587176D-1
      ALLC(4,2,1) =4.770079976D-1
C                     2P
      ALLZ(1,2,2) =1.798260992
      ALLZ(2,2,2) =4.662622228D-1
      ALLZ(3,2,2) =1.643718620D-1
      ALLZ(4,2,2) =6.543927065D-2
      ALLC(1,2,2) =5.713170255D-2
      ALLC(2,2,2) =2.857455515D-1
      ALLC(3,2,2) =5.517873105D-1
      ALLC(4,2,2) =2.632314924D-1
C                      3S
      ALLZ(1,3,1) =1.513265591
      ALLZ(2,3,1) =4.262497508D-1
      ALLZ(3,3,1) =7.643320863D-2
      ALLZ(4,3,1) =3.760545063D-2
      ALLC(1,3,1) =-3.295496352D-2
      ALLC(2,3,1) =-1.724516959D-1
      ALLC(3,3,1) =7.518511194D-1
      ALLC(4,3,1) =3.589627317D-1
C                     3P
      ALLZ(1,3,2) =1.853180239
      ALLZ(2,3,2) =1.915075719D-1
      ALLZ(3,3,2) =8.655487938D-2
      ALLZ(4,3,2) =4.184253862D-2
      ALLC(1,3,2) =-1.434249391D-2
      ALLC(2,3,2) =2.755177580D-1
      ALLC(3,3,2) =5.846750879D-1
      ALLC(4,3,2) =2.144986514D-1
C                      4S
      ALLZ(1,4,1) =3.242212833D-1
      ALLZ(2,4,1) =1.663217177D-1
      ALLZ(3,4,1) =5.081097451D-2
      ALLZ(4,4,1) =2.829066600D-2
      ALLC(1,4,1) =-1.120682822D-1
      ALLC(2,4,1) =-2.845426863D-1
      ALLC(3,4,1) =8.909873788D-1
      ALLC(4,4,1) =3.517811205D-1
C                     4P
      ALLZ(1,4,2) =1.492607880
      ALLZ(2,4,2) =4.327619272D-1
      ALLZ(3,4,2) =7.553156064D-2
      ALLZ(4,4,2) =3.706272183D-2
      ALLC(1,4,2) =-6.035216774D-3
      ALLC(2,4,2) =-6.013310874D-2
      ALLC(3,4,2) =6.451518200D-1
      ALLC(4,4,2) =4.117923820D-1
C                      5S
      ALLZ(1,5,1) =8.602284252D-1
      ALLZ(2,5,1) =1.189050200D-1
      ALLZ(3,5,1) =3.446076176D-2
      ALLZ(4,5,1) =1.974798796D-2
      ALLC(1,5,1) =1.103657561D-2
      ALLC(2,5,1) =-5.606519023D-1
      ALLC(3,5,1) =1.179429987
      ALLC(4,5,1) =1.734974376D-1
C                     5P
      ALLZ(1,5,2) =3.962838833D-1
      ALLZ(2,5,2) =1.838858552D-1
      ALLZ(3,5,2) =4.943555157D-2
      ALLZ(4,5,2) =2.750222273D-2
      ALLC(1,5,2) =-1.801459207D-2
      ALLC(2,5,2) =-1.360777372D-1
      ALLC(3,5,2) =7.533973719D-1
      ALLC(4,5,2) =3.409304859D-1
c 3d
      ALLZ(1,3,3) =9.185846715D-1
      ALLZ(2,3,3) =2.920461109D-1
      ALLZ(3,3,3) =1.187568890D-1
      ALLZ(4,3,3) =5.286755896D-2
      ALLC(1,3,3) =5.799057705D-2
      ALLC(2,3,3) =3.045581349D-1
      ALLC(3,3,3) =5.601358038D-1
      ALLC(4,3,3) =2.432423313D-1
c 4d
      ALLZ(1,4,3) =1.995825422
      ALLZ(2,4,3) =1.823461280D-1
      ALLZ(3,4,3) =8.197240896D-2
      ALLZ(4,4,3) =4.000634951D-2
      ALLC(1,4,3) =-2.816702620D-3
      ALLC(2,4,3) =2.177095871D-1
      ALLC(3,4,3) =6.058047348D-1
      ALLC(4,4,3) =2.717811257D-1
c 5d
      ALLZ(1,5,3) =4.230617826D-1
      ALLZ(2,5,3) =8.293863702D-2
      ALLZ(3,5,3) =4.590326388D-2
      ALLZ(4,5,3) =2.628744797D-2
      ALLC(1,5,3) =-2.421626009D-2
      ALLC(2,5,3) =3.937644956D-1
      ALLC(3,5,3) =5.489520286D-1
      ALLC(4,5,3) =1.190436963D-1

c 4f (the add. factors are required because the normal. function
c     below is not correct for f)
      ALLZ(1,4,4) =0.05691670217
      ALLZ(2,4,4) =0.2074585819
      ALLZ(3,4,4) =0.09298346885
      ALLZ(4,4,4) =0.04473508853
      ALLC(1,4,4) =0.05902730589/1.063832358490576**0.5
      ALLC(2,4,4) =0.3191828952 /1.063832358490576**0.5
      ALLC(3,4,4) =0.5639423893 /1.063832358490576**0.5
      ALLC(4,4,4) =0.2284796537 /1.063832358490576**0.5

      iam=l-1
      DO J=1,nprim
         cont(J)=ALLC(J,N,L)
         expo(J)=ALLZ(J,N,L)*zeta**2
         XNORM=(2.D0*EXPO(J)/PI)**0.75D0*(4.D0*EXPO(J))**(IAM/2.D0)/
     .          SQRT(DEX(2*IAM-1))
         cont(j)=cont(j)*xnorm
      ENDDO

      END

      SUBROUTINE SETgauss(nprim,n,l,zeta,expo,cont)
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      dimension expo(*),cont(*)
      integer iam,l
      real*8 DEX(-1:96),dex2

      nprim=1

      PI=4.D0*ATAN(1.D0)
      DO I=-1,10
         DEX(I)=DEX2(I)
      ENDDO

      iam=l-1
      expo(1)=zeta
      cont(1)=(2.D0*EXPO(1)/PI)**0.75D0*(4.D0*EXPO(1))**(IAM/2.D0)/
     .         SQRT(DEX(2*IAM-1))

      END

      SUBROUTINE SETSTO6(nprim,n,l,zeta,expo,cont)
      IMPLICIT DOUBLE PRECISION (A-H,O-Z)
      dimension expo(*),cont(*)
      dimension ALLC(6,6,3),ALLZ(6,6,3)
      integer iam,nprim
      real*8 DEX(-1:96)

      nprim=6

      PI=4.D0*ATAN(1.D0)
      DO I=-1,10
         DEX(I)=DEX2(I)
      ENDDO

C                                     1S
      ALLZ(1,1,1) =2.310303149D01
      ALLZ(2,1,1) =4.235915534D00
      ALLZ(3,1,1) =1.185056519D00
      ALLZ(4,1,1) =4.070988982D-01
      ALLZ(5,1,1) =1.580884151D-01
      ALLZ(6,1,1) =6.510953954D-02
      ALLC(1,1,1) =9.163596280D-03
      ALLC(2,1,1) =4.936149294D-02
      ALLC(3,1,1) =1.685383049D-01
      ALLC(4,1,1) =3.705627997D-01
      ALLC(5,1,1) =4.164915298D-01
      ALLC(6,1,1) =1.303340841D-01
C                                      2S
      ALLZ(1,2,1) =2.768496241D01
      ALLZ(2,2,1) =5.077140627D00
      ALLZ(3,2,1) =1.426786050D00
      ALLZ(4,2,1) =2.040335729D-01
      ALLZ(5,2,1) =9.260298399D-02
      ALLZ(6,2,1) =4.416183978D-02
      ALLC(1,2,1) =-4.151277819D-03
      ALLC(2,2,1) =-2.067024148D-02
      ALLC(3,2,1) =-5.150303337D-02
      ALLC(4,2,1) =3.346271174D-01
      ALLC(5,2,1) =5.621061301D-01
      ALLC(6,2,1) =1.712994697D-01
C                                     2P
      ALLZ(1,2,2) =5.868285913D00
      ALLZ(2,2,2) =1.530329631D00
      ALLZ(3,2,2) =5.475665231D-01
      ALLZ(4,2,2) =2.288932733D-01
      ALLZ(5,2,2) =1.046655969D-01
      ALLZ(6,2,2) =4.948220127D-02
      ALLC(1,2,2) =7.924233646D-03
      ALLC(2,2,2) =5.144104825D-02
      ALLC(3,2,2) =1.898400060D-01
      ALLC(4,2,2) =4.049863191D-01
      ALLC(5,2,2) =4.012362861D-01
      ALLC(6,2,2) =1.051855189D-01
C                                      3S
      ALLZ(1,3,1) =3.273031938D00
      ALLZ(2,3,1) =9.200611311D-01
      ALLZ(3,3,1) =3.593349765D-01
      ALLZ(4,3,1) =8.636686991D-02
      ALLZ(5,3,1) =4.797373812D-02
      ALLZ(6,3,1) =2.724741144D-02
      ALLC(1,3,1) =-6.775596947D-03
      ALLC(2,3,1) =-5.639325779D-02
      ALLC(3,3,1) =-1.587856086D-01
      ALLC(4,3,1) =5.534527651D-01
      ALLC(5,3,1) =5.015351020D-01
      ALLC(6,3,1) =7.223633674D-02
C                                     3P
      ALLZ(1,3,2) =5.077973607D00
      ALLZ(2,3,2) =1.340786940D00
      ALLZ(3,3,2) =2.248434849D-01
      ALLZ(4,3,2) =1.131741848D-01
      ALLZ(5,3,2) =6.076408893D-02
      ALLZ(6,3,2) =3.315424265D-02
      ALLC(1,3,2) =-3.329929840D-03
      ALLC(2,3,2) =-1.419488340D-02
      ALLC(3,3,2) =1.639395770D-01
      ALLC(4,3,2) =4.485358256D-01
      ALLC(5,3,2) =3.908813050D-01
      ALLC(6,3,2) =7.411456232D-02

C                                     3d
      ALLZ(1,3,3) =2.488296923
      ALLZ(2,3,3) =7.981487853D-1
      ALLZ(3,3,3) =3.311327490D-1
      ALLZ(4,3,3) =1.559114463D-1
      ALLZ(5,3,3) =7.817734732D-2
      ALLZ(6,3,3) =4.058484363D-2
      ALLC(1,3,3) =7.283828112D-3
      ALLC(2,3,3) =5.386799363D-2
      ALLC(3,3,3) =2.072139149D-1
      ALLC(4,3,3) =4.266269092D-1
      ALLC(5,3,3) =3.843100204D-1
      ALLC(6,3,3) =8.902827546D-2
C                                     4S
      ALLZ(1,4,1) = 1.365346D+00
      ALLZ(2,4,1) = 4.393213D-01
      ALLZ(3,4,1) = 1.877069D-01
      ALLZ(4,4,1) = 9.360270D-02
      ALLZ(5,4,1) = 5.052263D-02
      ALLZ(6,4,1) = 2.809354D-02
      ALLC(1,4,1) = 3.775056D-03
      ALLC(2,4,1) =-5.585965D-02
      ALLC(3,4,1) =-3.192946D-01
      ALLC(4,4,1) =-2.764780D-02
      ALLC(5,4,1) = 9.049199D-01
      ALLC(6,4,1) = 3.406258D-01
C                                   4P
      ALLC(1,4,2) =-7.052075D-03
      ALLC(2,4,2) =-5.259505D-02
      ALLC(3,4,2) =-3.773450D-02
      ALLC(4,4,2) = 3.874773D-01
      ALLC(5,4,2) = 5.791672D-01
      ALLC(6,4,2) = 1.221817D-01
      ALLZ(1,4,2) = 1.365346D+00
      ALLZ(2,4,2) = 4.393213D-01
      ALLZ(3,4,2) = 1.877069D-01
      ALLZ(4,4,2) = 9.360270D-02
      ALLZ(5,4,2) = 5.052263D-02
      ALLZ(6,4,2) = 2.809354D-02
C                                     5S
      ALLZ(1,5,1) = 7.701420258D-01
      ALLZ(2,5,1) = 2.756268915D-01
      ALLZ(3,5,1) = 1.301847480D-01
      ALLZ(4,5,1) = 6.953441940D-02
      ALLZ(5,5,1) = 4.002545502D-02
      ALLZ(6,5,1) = 2.348388309D-02
      ALLC(1,5,1) = 1.267447151D-02
      ALLC(2,5,1) = 3.266734789D-03
      ALLC(3,5,1) =-4.307553999D-01
      ALLC(4,5,1) =-3.231998963D-01
      ALLC(5,5,1) = 1.104322879D+00
      ALLC(6,5,1) = 4.368498703D-01
C                                      5P
      ALLZ(1,5,2) = 7.701420258D-01
      ALLZ(2,5,2) = 2.756268915D-01
      ALLZ(3,5,2) = 1.301847480D-01
      ALLZ(4,5,2) = 6.953441940D-02
      ALLZ(5,5,2) = 4.002545502D-02
      ALLZ(6,5,2) = 2.348388309D-02
      ALLC(1,5,2) =-1.105673292D-03
      ALLC(2,5,2) =-6.243132446D-02
      ALLC(3,5,2) =-1.628476766D-01
      ALLC(4,5,2) = 3.210328714D-01
      ALLC(5,5,2) = 6.964579592D-01
      ALLC(6,5,2) = 1.493146125D-01
C                                   6S
      ALLZ(1,6,1) = 5.800292686D-01
      ALLZ(2,6,1) = 2.718262251D-01
      ALLZ(3,6,1) = 7.938523262D-02
      ALLZ(4,6,1) = 4.975088254D-02
      ALLZ(5,6,1) = 2.983643556D-02
      ALLZ(6,6,1) = 1.886067216D-02
      ALLC(1,6,1) = 4.554359511D-03
      ALLC(2,6,1) = 5.286443143D-02
      ALLC(3,6,1) =-7.561016358D-01
      ALLC(4,6,1) =-2.269803820D-01
      ALLC(5,6,1) = 1.332494651D+00
      ALLC(6,6,1) = 3.622518293D-01
C                                   6P
      ALLZ(1,6,2) = 6.696537714D-01
      ALLZ(2,6,2) = 1.395089793D-01
      ALLZ(3,6,2) = 8.163894960D-02
      ALLZ(4,6,2) = 4.586329272D-02
      ALLZ(5,6,2) = 2.961305556D-02
      ALLZ(6,6,2) = 1.882221321D-02
      ALLC(1,6,2) = 2.782723680D-03
      ALLC(2,6,2) =-1.282887780D-01
      ALLC(3,6,2) =-2.266255943D-01
      ALLC(4,6,2) = 4.682259383D-01
      ALLC(5,6,2) = 6.752048848D-01
      ALLC(6,6,2) = 1.091534212D-01

      iam=l-1
      DO J=1,nprim
         cont(J)=ALLC(J,N,L)
         expo(J)=ALLZ(J,N,L)*zeta**2
         XNORM=(2.D0*EXPO(J)/PI)**0.75D0*(4.D0*EXPO(J))**(IAM/2.D0)/
     .          SQRT(DEX(2*IAM-1))
         cont(j)=cont(j)*xnorm
      ENDDO

      RETURN
      END

