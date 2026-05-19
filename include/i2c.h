#ifndef I2C_H
#define I2C_H

#include <stdint.h>

void    i2c1_init(void);
void    i2c_read_bytes(uint8_t addr7, uint8_t reg, uint8_t *buf, uint8_t len);
void    i2c_write_reg(uint8_t addr7, uint8_t reg, uint8_t value);

/* Legacy stubs — kept for compatibility */
void    i2c_start(void);
void    i2c_stop(void);
uint8_t i2c_send_addr(uint8_t addr7, uint8_t dir);
uint8_t i2c_write_byte(uint8_t data);
uint8_t i2c_read_ack(void);
uint8_t i2c_read_nack(void);

#endif