#ifndef MPU6050_H
#define MPU6050_H

#include <stdint.h>

/* I2C address — AD0 pin low = 0x68, high = 0x69 */
#define MPU6050_ADDR       0x68

/* Register addresses */
#define MPU6050_PWR_MGMT_1 0x6B
#define MPU6050_WHO_AM_I   0x75
#define MPU6050_ACCEL_XOUT_H 0x3B
#define MPU6050_GYRO_XOUT_H  0x43
/* Add this */
#define MPU6050_WHO_AM_I_VALID_A  0x68   /* genuine MPU6050 */
#define MPU6050_WHO_AM_I_VALID_B  0x70   /* clone — ICM-20600 or similar */

typedef struct {
    int16_t x, y, z;
} mpu6050_vec3_t;

/*
 * Returns 0 on success, 1 on failure (WHO_AM_I mismatch or bus error).
 * Call this once at startup. If it returns 1, check your wiring.
 */
int  mpu6050_init(void);

void mpu6050_read_accel(mpu6050_vec3_t *out);
void mpu6050_read_gyro(mpu6050_vec3_t *out);

#endif