!*****************************************************************************************
!>
! Module for the 27th unit test.

module jf_test_27_mod

    use json_module, rk => json_rk, lk => json_lk, ik => json_ik, ck => json_ck, cdk => json_cdk
    use, intrinsic :: iso_fortran_env , only: error_unit, output_unit

    implicit none

contains

    subroutine test_27(error_cnt)

    !! Test the printing of vectors on one line

    implicit none

    integer,intent(out) :: error_cnt

    type(json_value),pointer :: p
    type(json_core) :: json
    type(json_file) :: f

    character(kind=CK,len=*),parameter :: json_str = &
            '{"int_vec": [1,2,3], "int": 1, "object": {"int_vec": [1,2,3]},'//&
            '"vec": [[1,2],[3,4]], "vec_of_objects": [{"a":1},{"bvec":[1,2,3]}]}'

    error_cnt = 0
    call json%initialize(compress_vectors=.true.)
    if (json%failed()) then
      call json%print_error_message(error_unit)
      error_cnt = error_cnt + 1
    end if

    write(error_unit,'(A)') ''
    write(error_unit,'(A)') '================================='
    write(error_unit,'(A)') '   TEST 27'
    write(error_unit,'(A)') '================================='
    write(error_unit,'(A)') ''

    write(error_unit,'(A)') ''
    write(error_unit,'(A)') 'JSON string: '//json_str

    write(error_unit,'(A)') ''
    write(error_unit,'(A)') 'parsing...'
    call json%parse(p,json_str)
    if (json%failed()) then
      call json%print_error_message(error_unit)
      error_cnt = error_cnt + 1
    end if

    write(error_unit,'(A)') ''
    write(error_unit,'(A)') 'printing...'
    call json%print(p,output_unit)

    ! test json_file interface
    f = json_file(p)
    call f%initialize(compress_vectors=.true.)
    call f%print_file()

    if (f%failed()) then
      call f%print_error_message(error_unit)
      error_cnt = error_cnt + 1
    end if

    ! clean up
    write(error_unit,'(A)') ''
    write(error_unit,'(A)') 'destroy...'
    call json%destroy(p)
    if (json%failed()) then
        call json%print_error_message(error_unit)
        error_cnt = error_cnt + 1
    end if

    end subroutine test_27

end module jf_test_27_mod
!*****************************************************************************************

!*****************************************************************************************
program jf_test_27

    !! 27th unit test.

    use jf_test_27_mod , only: test_27
    implicit none
    integer :: n_errors
    n_errors = 0
    call test_27(n_errors)
    if (n_errors /= 0) stop 1

end program jf_test_27
!*****************************************************************************************
