## tap_testname = dataset creation - simple dataspace with integral datatype
HDF5 "test12.h5" {
GROUP "/" {
    DATASET "def" {
        DATATYPE H5T_STD_U32LE
        DATASPACE SIMPLE { ( 10, 10 ) / ( 10, 10 ) }
        DATA {
            (0,0): 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
            (1,0): 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
            (2,0): 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
            (3,0): 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
            (4,0): 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
            (5,0): 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
            (6,0): 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
            (7,0): 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
            (8,0): 0, 1, 2, 3, 4, 5, 6, 7, 8, 9,
            (9,0): 0, 1, 2, 3, 4, 5, 6, 7, 8, 9
        }
    }
}
}