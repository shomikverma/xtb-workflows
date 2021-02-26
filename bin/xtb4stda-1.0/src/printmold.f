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

ccccccccccccccccccccccccccccccccc
!    write out Molden input     c
ccccccccccccccccccccccccccccccccc
! ncent  : # atoms
! nmo    : # MOs
! nbf    : # AOs
! nprims : # primitives (in total)
! xyz(4,ncent) : Cartesian coordinates & nuclear charge
! cxip(nprims) : contraction coefficients of primitives
! exip(nprims) : exponents of primitives
! cmo(nbf,nmo) : LCAO-MO coefficients
! eval(nmo)    : orbital eigenvalues
! occ(nmo)     : occupation # of MO
! ipty(nprims) : angular momentum of primitive function
! ipao(nbf)    : # primitives in contracted AO
! ibf(ncent)   : # of contracted AOs on atom


      subroutine printmold(ncent,nmo,nbf,xyz,at,cmo,eval,
     .                     occ,thr)

      include 'ehtcommon.fh'

      real*8, intent ( in ) :: xyz(3,ncent)
      real*8, intent ( in ) :: eval(nmo)
      real*8, intent ( in ) :: occ (nmo)
      real*8, intent ( in ) :: cmo(nbf,nmo)
      real*8, intent ( in ) :: thr
      integer, intent( in ) :: at(ncent)
      integer, intent( in ) :: ncent,nmo,nbf
      ! temporary variables
      integer i,j,k,icount,jcount,z,nmomax,nop
      real*8 dum
      character*1 aang
      character*2 atyp
      logical skip

      iwfn=29
      open(unit=iwfn,file='molden.input',status='replace')


      write(iwfn,'(A)',advance='yes')'[Molden Format]'
      write(iwfn,'(A)',advance='yes')'[Title]'

ccccccccccccccccccccccccccccccccccccccccccccccccc
! print out atoms & coordinates                 c
ccccccccccccccccccccccccccccccccccccccccccccccccc

      write(iwfn,'(A)',advance='yes')'[Atoms] AU'
! either coordinates are given in a.u.
        do i = 1,ncent
         call aasym(at(i),atyp)
         z=at(i)
         ! atom character, running number, nuclear charge, x,y,z coordinates
         write (iwfn,'(a2,2i6,3E22.14)')
     .   atyp,i,z,xyz(1,i),xyz(2,i),xyz(3,i)
        enddo
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
! Now print basis set data                                   c
!                                                            c
! go through atoms and assign orbitals (contracted & prims)  c
! search for [GTO] statement to read basis set data          c
! for each set of atomic orbitals                            c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      write(iwfn,'(A)',advance='yes') '[GTO]'
cccccccccccccccccccc
c go through atoms c
cccccccccccccccccccc
      icount=1
      do i=1,ncent
         write(iwfn,*) i,'0' ! I don't know what the zero is needed for
!  now go trough nbfs located on atom i
         do j=fila(1,i),fila(2,i)
           call ang2chr(lao(j),aang,skip)
           if(skip)then
            do k=1,nprim(j)
              icount=icount+1
            enddo
           else
            write(iwfn,*) aang,nprim(j),1.00
            do k=1,nprim(j)
              write(iwfn,*) alp(icount),cont(icount)
              icount=icount+1
            enddo
           endif
         enddo
         write(iwfn,*)
      enddo

      nmomax=0
      do i=1,nmo
         if(eval(i).gt.thr.and.nmomax.eq.0)nmomax=i-1
      enddo
      if(nmomax.eq.0) nmomax=nmo

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
! print occupation number of orbitals and orbital energies c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      write(iwfn,'(A)',advance='yes') '[MO]'
      ! restricted printout
        do i=1,nmomax
          ! MO info
          write(iwfn,'(A)',advance='no') 'Sym= '
          write(iwfn,'(i5,a1)') i,'a'
          write(iwfn,'(A)',advance='no') 'Ene= '
          dum=0
          write(iwfn,*) eval(i)
          write(iwfn,'(A)',advance='no') 'Spin= '
          write(iwfn,'(A)',advance='yes') 'Alpha' ! for now just consider RHF case
          write(iwfn,'(A)',advance='no') 'Occup= '
          write(iwfn,'(F14.8)') occ(i)
          !now coefficients
          ! a notion: for l>0, the ordering is p: x,y,z ; d: xx,yy,zz,xy,xz,yz ; f: xxx, yyy, zzz, xxy, xxz, yyx, yyz, xzz, yzz, xyz
          do j=1,nbf
             write(iwfn,*) j,cmo(j,i)
          enddo
        enddo
      close(iwfn)
      end

c true U version
      subroutine printumold(ncent,nmo,nbf,xyz,at,cmoa,cmob,evala,
     .                      evalb,occa,occb,thr)

      include 'ehtcommon.fh'

      real*8, intent ( in ) :: xyz(3,ncent)
      real*8, intent ( in ) :: evala(nmo)
      real*8, intent ( in ) :: evalb(nmo)
      real*8, intent ( in ) :: occa(nmo)
      real*8, intent ( in ) :: occb(nmo)
      real*8, intent ( in ) :: cmoa(nbf,nmo)
      real*8, intent ( in ) :: cmob(nbf,nmo)
      real*8, intent ( in ) :: thr
      integer, intent( in ) :: at(ncent)
      integer, intent( in ) :: ncent,nmo,nbf
      ! temporary variables
      integer i,j,k,icount,jcount,z,nmomax,nop
      real*8 dum
      character*1 aang
      character*2 atyp
      logical skip

      iwfn=29
      open(unit=iwfn,file='molden.input',status='replace')

      write(iwfn,'(A)',advance='yes')'[Molden Format]'
      write(iwfn,'(A)',advance='yes')'[Title]'

ccccccccccccccccccccccccccccccccccccccccccccccccc
! print out atoms & coordinates                 c
ccccccccccccccccccccccccccccccccccccccccccccccccc

      write(iwfn,'(A)',advance='yes')'[Atoms] AU'
! either coordinates are given in a.u.
        do i = 1,ncent
         call aasym(at(i),atyp)
         z=at(i)
         ! atom character, running number, nuclear charge, x,y,z coordinates
         write (iwfn,'(a2,2i6,3E22.14)')
     .   atyp,i,z,xyz(1,i),xyz(2,i),xyz(3,i)
        enddo
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
! Now print basis set data                                   c
!                                                            c
! go through atoms and assign orbitals (contracted & prims)  c
! search for [GTO] statement to read basis set data          c
! for each set of atomic orbitals                            c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      write(iwfn,'(A)',advance='yes') '[GTO]'
cccccccccccccccccccc
c go through atoms c
cccccccccccccccccccc
      icount=1
      do i=1,ncent
         write(iwfn,*) i,'0' ! I don't know what the zero is needed for
!  now go trough nbfs located on atom i
         do j=fila(1,i),fila(2,i)
           call ang2chr(lao(j),aang,skip)
           if(skip)then
            do k=1,nprim(j)
              icount=icount+1
            enddo
           else
            write(iwfn,*) aang,nprim(j),1.00
            do k=1,nprim(j)
              write(iwfn,*) alp(icount),cont(icount)
              icount=icount+1
            enddo
           endif
         enddo
         write(iwfn,*)
      enddo

      nmomax=0
      do i=1,nmo
         if(evala(i).gt.thr.and.nmomax.eq.0)nmomax=i-1
      enddo
      if(nmomax.eq.0) nmomax=nmo

cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
! print occupation number of orbitals and orbital energies c
cccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
      write(iwfn,'(A)',advance='yes') '[MO]'
        ! Alpha MOs
        do i=1,nmomax
          write(iwfn,'(A)',advance='no') 'Sym= '
          write(iwfn,'(i5,a1)') i,'a (alpha)'
          write(iwfn,'(A)',advance='no') 'Ene= '
          write(iwfn,*) evala(i)
          write(iwfn,'(A)',advance='no') 'Spin= '
          write(iwfn,'(A)',advance='yes') 'Alpha'
          write(iwfn,'(A)',advance='no') 'Occup= '
          write(iwfn,'(F14.8)') occa(i)
          !now coefficients
          ! a notion: for l>0, the ordering is p: x,y,z ; d: xx,yy,zz,xy,xz,yz ; f: xxx, yyy, zzz, xxy, xxz, yyx, yyz, xzz, yzz, xyz
          do j=1,nbf
             write(iwfn,*) j,cmoa(j,i)
          enddo
        enddo
        ! Beta MOs
        do i=1,nmomax
          write(iwfn,'(A)',advance='no') 'Sym= '
          write(iwfn,'(i5,a1)') i,'a (beta)'
          write(iwfn,'(A)',advance='no') 'Ene= '
          write(iwfn,*) evalb(i)
          write(iwfn,'(A)',advance='no') 'Spin= '
          write(iwfn,'(A)',advance='yes') 'Beta'
          write(iwfn,'(A)',advance='no') 'Occup= '
          write(iwfn,'(F14.8)') occb(i)
          !now coefficients
          ! a notion: for l>0, the ordering is p: x,y,z ; d: xx,yy,zz,xy,xz,yz ; f: xxx, yyy, zzz, xxy, xxz, yyx, yyz, xzz, yzz, xyz
          do j=1,nbf
             write(iwfn,*) j,cmob(j,i)
          enddo
        enddo

      close(iwfn)
      end

! this routine gives character s,p,d etc. if angular momentum is given as input (i.e., 0,1,2 etc.)
      subroutine ang2chr(iang,chr,skip)
      implicit none
      character*1, intent( out ) :: chr
      integer, intent( in ) :: iang
      logical, intent( inout ) :: skip

         skip=.false.
         select case(iang)
          case(1)
           chr='s'
          case(2)
           chr='p'
          case(3)
           chr='p'
           skip=.true.
          case(4)
           chr='p'
           skip=.true.
          case(5)
           chr='d'
          case(6)
           chr='d'
           skip=.true.
          case(7)
           chr='d'
           skip=.true.
          case(8)
           chr='d'
           skip=.true.
          case(9)
           chr='d'
           skip=.true.
          case(10)
           chr='d'
           skip=.true.
         end select
      end




cccccccccccccccccccccccccccccccccccccccccccccc
c
c specifies the length of an integer
c
cccccccccccccccccccccccccccccccccccccccccccccc
      subroutine lenint(iin,iout)
      implicit none
      integer, intent( in ) :: iin
      integer, intent( out) :: iout
      integer mdim,jdim
      jdim=0
      iout=0
      do
      iout=iout+1
      jdim=10*jdim+9
      mdim=iin-jdim
      if(mdim.le.0) exit
      enddo
      return
      end

C     *****************************************************************

      subroutine AASYM(I,asy)
      integer, intent ( in ) :: i
      CHARACTER*2 ASY
      CHARACTER*2 ELEMNT(107), AS
      DATA ELEMNT/'h ','he',
     1 'li','be','b ','c ','n ','o ','f ','ne',
     2 'na','mg','al','si','p ','s ','cl','ar',
     3 'k ','ca','sc','ti','v ','cr','mn','fe','co','ni','cu',
     4 'zn','ga','ge','as','se','br','kr',
     5 'rb','sr','y ','zr','nb','mo','tc','ru','rh','pd','ag',
     6 'cd','in','sn','sb','te','i ','xe',
     7 'cs','ba','la','ce','pr','nd','pm','sm','eu','gd','tb','dy',
     8 'ho','er','tm','yb','lu','hf','ta','w ','re','os','ir','pt',
     9 'au','hg','tl','pb','bi','po','at','rn',
     1 'fr','ra','ac','th','pa','u ','np','pu','am','cm','bk','cf','xx',
     2 'fm','md','cb','xx','xx','xx','xx','xx'/
      AS=ELEMNT(I)
      CALL UPPER(AS)
      ASY=AS
      if(i.eq.103) asy='XX'
      RETURN
      END


