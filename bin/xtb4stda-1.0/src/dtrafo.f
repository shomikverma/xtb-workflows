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

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c transforms cao(6d) integrals to sao(5d) basis
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

      subroutine cao2sao(nbf,nao,s)
      implicit none
      include 'ehtcommon.fh'
      integer nbf,nao
      real*8  s(nbf,nbf)
      real*8  sspher
      integer lll(20),firstd(nbf)
      integer i,j,k,ii,jj,kk,iii,jjj,lin,li,lj,mm,nn,m,n
      data lll/1,2,2,2,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4/

      real*8 trafo(6,6)
      real*8,allocatable :: sneu(:)

      trafo = 0.0d0
c dS
      trafo(1,1)=1.d0/sqrt(3.d0)*sqrt(3.d0/5.d0)
      trafo(2,1)=1.d0/sqrt(3.d0)*sqrt(3.d0/5.d0)
      trafo(3,1)=1.d0/sqrt(3.d0)*sqrt(3.d0/5.d0)
c dx2-y2
      trafo(1,2)= 1.d0/sqrt(2.d0)*sqrt(3.d0/2.d0)
      trafo(2,2)=-1.d0/sqrt(2.d0)*sqrt(3.d0/2.d0)
c dz2
      trafo(1,3)= 0.50d0
      trafo(2,3)= 0.50d0
      trafo(3,3)=-1.0d0
!      trafo(1,3)= 0.408248290464D+00*sqrt(3./2.)
!      trafo(2,3)= 0.408248290464D+00*sqrt(3./2.)
!      trafo(3,3)=-0.816496580928D+00*sqrt(3./2.)
c rest
      trafo(4,4)=1.0d0
      trafo(5,5)=1.0d0
      trafo(6,6)=1.0d0

      nao=0
      firstd = 0
      i=1
 42   if(lao(i).gt.4.and.lao(i).le.10)then
         nao=nao+1
         firstd(i:i+5)=i
         i=i+5
      endif
      i=i+1
      if(i.lt.nbf)goto 42

      if(nao.eq.0) then
         nao=nbf
         return
      endif

      allocate(sneu(nbf*(nbf+1)/2))

      k=0
      do i=1,nbf
         do j=1,i
            k=K+1
            sneu(k)=s(j,i)
         enddo
      enddo

      k=0
      do i=1,nbf
         li=lll(lao(i))
         do j=1,i
            lj=lll(lao(j))
            k=k+1
c d-d
            if(li.eq.3.and.lj.eq.3)then
               ii=lao(i)-4
               jj=lao(j)-4
               sspher=0
               do m=1,6
                  mm=firstd(i)-1+m
                  do n=1,6
                     nn=firstd(j)-1+n
                     sspher=sspher+trafo(m,ii)*trafo(n,jj)*s(mm,nn)
                  enddo
               enddo
               sneu(k)=sspher
            endif
c d-sp
            if(li.eq.3.and.lj.le.2)then
               ii=lao(i)-4
               sspher=0
               do m=1,6
                  mm=firstd(i)-1+m
                     sspher=sspher+trafo(m,ii)*s(mm,j)
               enddo
               sneu(k)=sspher
            endif
c sp-d
            if(li.le.2.and.lj.eq.3)then
               jj=lao(j)-4
               sspher=0
                  do n=1,6
                     nn=firstd(j)-1+n
                     sspher=sspher+trafo(n,jj)*s(i,nn)
                  enddo
               sneu(k)=sspher
            endif

         enddo
      enddo

      s=0

      k=0
      iii=0
      do i=1,nbf
         if(lao(i).ne.5)iii=iii+1
         jjj=0
         do j=1,i
            if(lao(j).ne.5)jjj=jjj+1
            k=k+1
            if(lao(i).eq.5.or.lao(j).eq.5)cycle
            s(iii,jjj)=sneu(k)
            s(jjj,iii)=sneu(k)
         enddo
      enddo

      nao=nbf-nao

      deallocate(sneu)
      end

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c transforms sao(5d) integrals to cao(6d) basis
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

      subroutine sao2cao(nbf,s,ncao,x)
      implicit none
      include 'ehtcommon.fh'
      integer nbf,new,ncao
      real*8  s(nbf,nbf),x(ncao,nbf)
      real*8  xcart
      integer lll(20),firstd(nbf),idprev
      integer i,j,k,jj,mm,m
      data lll/1,2,2,2,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4/

      real*8 trafo(5,6)

      trafo = 0.0d0
! x2
      trafo(1,1)=1./sqrt(2.)*sqrt(3./2.)
!      trafo(2,1)=0.408248290464D+00*sqrt(3./2.)
      trafo(2,1)=0.50d0
! y2
      trafo(1,2)=-1./sqrt(2.)*sqrt(3./2.)
!      trafo(2,2)=0.408248290464D+00*sqrt(3./2.)
      trafo(2,2)=0.50d0
! z2
      trafo(1,3)=0.0d0
      trafo(2,3)=-1.0d0
!      trafo(2,3)=-0.816496580928D+00*sqrt(3./2.)
c rest
      trafo(3,4)=1.0d0
      trafo(4,5)=1.0d0
      trafo(5,6)=1.0d0

      new=ncao-nbf

      if(new.eq.0) then
         return
      endif

      firstd = 0
      i=1
      j=0
      ! lao is still in old dimensions (i.e., ncao) while s comes with nsao
 42   if(lao(i).gt.4.and.lao(i).le.10)then
         firstd(i-j:i-j+4)=i-j
         j=j+1
         i=i+5
      endif
      i=i+1
      if(i.lt.ncao)goto 42
      ! sanity check
      if(new.ne.j) stop 'error in sao2cao trafo'

      x=0.0d0

      do i=1,nbf ! go through eigenvectors
         k = 0
         idprev=0
         do j=1,nbf ! go through LCAO-MO coefficients
            if(idprev.gt.0.and.firstd(j).eq.idprev) cycle
            if(firstd(j).gt.idprev)then ! if a set of d functions is found, do trafo for all six d orbitals
               do jj=1,6
                 k=k+1
                 xcart=0.0d0
                 do m=1,5
                    mm=firstd(j)-1+m
                    xcart=xcart+trafo(m,jj)*s(mm,i)
                 enddo
                 x(k,i)=xcart
                enddo
                idprev=firstd(j) ! setting idprev to new value guarantees that the following 4 spherical d functions will be skipped (we already did the trafo)
                cycle
            endif
            k=k+1
            x(k,i)= s(j,i)
         enddo
         if (k.ne.ncao) stop 'error in eigenvector dimension'
      enddo

      end

ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c transforms cao(6d) integrals to sao(5d) basis, packed output
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc

      subroutine cao2saop(nbf,nao,s)
      implicit none
      include 'ehtcommon.fh'
      integer nbf,nao
      real*8  s(nbf*(nbf+1)/2)
      real*8  sspher
      integer lll(20),firstd(nbf)
      integer i,j,k,ii,jj,kk,iii,jjj,lin,li,lj,mm,nn,m,n
      data lll/1,2,2,2,3,3,3,3,3,3,4,4,4,4,4,4,4,4,4,4/

      real*8 trafo(6,6)
      real*8,allocatable :: sneu(:)

      trafo = 0.0d0
c dS
      trafo(1,1)=1.d0/sqrt(3.d0)*sqrt(3.d0/5.d0)
      trafo(2,1)=1.d0/sqrt(3.d0)*sqrt(3.d0/5.d0)
      trafo(3,1)=1.d0/sqrt(3.d0)*sqrt(3.d0/5.d0)
c dx2-y2
      trafo(1,2)= 1.d0/sqrt(2.d0)*sqrt(3.d0/2.d0)
      trafo(2,2)=-1.d0/sqrt(2.d0)*sqrt(3.d0/2.d0)
c dz2
      trafo(1,3)= 0.50d0
      trafo(2,3)= 0.50d0
      trafo(3,3)=-1.0d0
c rest
      trafo(4,4)=1.0d0
      trafo(5,5)=1.0d0
      trafo(6,6)=1.0d0

      nao=0
      firstd = 0
      i=1
 42   if(lao(i).gt.4.and.lao(i).le.10)then
         nao=nao+1
         firstd(i:i+5)=i
         i=i+5
      endif
      i=i+1
      if(i.lt.nbf)goto 42

      if(nao.eq.0) then
         nao=nbf
         return
      endif

      allocate(sneu(nbf*(nbf+1)/2))

      sneu = s

      k=0
      do i=1,nbf
         li=lll(lao(i))
         do j=1,i
            lj=lll(lao(j))
            k=k+1
c d-d
            if(li.eq.3.and.lj.eq.3)then
               ii=lao(i)-4
               jj=lao(j)-4
               sspher=0
               do m=1,6
                  mm=firstd(i)-1+m
                  do n=1,6
                     nn=firstd(j)-1+n
                     sspher=sspher+trafo(m,ii)*trafo(n,jj)*s(lin(mm,nn))
                  enddo
               enddo
               sneu(k)=sspher
            endif
c d-sp
            if(li.eq.3.and.lj.le.2)then
               ii=lao(i)-4
               sspher=0
               do m=1,6
                  mm=firstd(i)-1+m
                     sspher=sspher+trafo(m,ii)*s(lin(mm,j))
               enddo
               sneu(k)=sspher
            endif
c sp-d
            if(li.le.2.and.lj.eq.3)then
               jj=lao(j)-4
               sspher=0
                  do n=1,6
                     nn=firstd(j)-1+n
                     sspher=sspher+trafo(n,jj)*s(lin(i,nn))
                  enddo
               sneu(k)=sspher
            endif

         enddo
      enddo

      s(1:nao*(nao+1)/2)=0

      k=0
      iii=0
      do i=1,nbf
         if(lao(i).ne.5)iii=iii+1
         jjj=0
         do j=1,i
            if(lao(j).ne.5)jjj=jjj+1
            k=k+1
            if(lao(i).eq.5.or.lao(j).eq.5)cycle
            s(lin(iii,jjj))=sneu(k)
         enddo
      enddo

      nao=nbf-nao

      deallocate(sneu)
      end

