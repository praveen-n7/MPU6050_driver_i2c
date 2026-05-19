#include "stm32f4xx.h"
#include "uart.h"
#include "i2c.h"
#include "mpu6050.h"
#include <stdint.h>

extern uint8_t _heap_start;
extern uint8_t _heap_end;

void *_sbrk(int incr)
{
    static uint8_t *heap_ptr = &_heap_start;
    uint8_t *prev = heap_ptr;
    if ((heap_ptr + incr) > &_heap_end) return (void *)-1;
    heap_ptr += incr;
    return (void *)prev;
}

static void delay_ms(uint32_t ms)
{
    volatile uint32_t count = ms * 4000;
    while (count--);
}

int main(void)
{
    uart2_init(115200);
    i2c1_init();
    uart2_send_string("\r\n=== MPU6050 bare-metal driver ===\r\n");
    delay_ms(2000);

    if (mpu6050_init() != 0) {
        uart2_send_string("ERROR: init failed.\r\n");
        while (1);
    }

    uart2_send_string("Sensor OK\r\n\r\n");

    mpu6050_vec3_t accel, gyro;
    while (1) {
        mpu6050_read_accel(&accel);
        mpu6050_read_gyro(&gyro);
        uart2_printf(
            "ACCEL  X=%7d  Y=%7d  Z=%7d  |  "
            "GYRO  X=%7d  Y=%7d  Z=%7d\r\n",
            accel.x, accel.y, accel.z,
            gyro.x,  gyro.y,  gyro.z
        );
        delay_ms(500);
    }
}