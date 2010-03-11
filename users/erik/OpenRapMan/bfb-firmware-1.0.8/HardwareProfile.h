
#ifndef _HARDWAREPROFILE_H_
#define _HARDWAREPROFILE_H_


#define RUN_AT_80MHZ
#define GetSystemClock()            (80000000ul)
#define GetPeripheralClock()        (GetSystemClock()/2) 
#define GetInstructionClock()       (GetSystemClock())
#define MILLISECONDS_PER_TICK       10                  
#define TIMER_PRESCALER             TIMER_PRESCALER_8   
#define TIMER_PERIOD                37500               


#define USE_SD_INTERFACE_WITH_SPI

//I guess here we need SPI2 as PIC32MX440H only has SPI2 
#define MDD_USE_SPI_2

#define SPI_START_CFG_1     (PRI_PRESCAL_64_1 | SEC_PRESCAL_8_1 | MASTER_ENABLE_ON | SPI_CKE_ON | SPI_SMP_ON)
#define SPI_START_CFG_2     (SPI_ENABLE)
#define SPI_FREQUENCY			(20000000)
    
// SD-SPI
#define SD_CS               PORTBbits.RB1 // Chip Select Output bit
#define SD_CD               PORTEbits.RE4 // Card Detect Input bit
#define SD_WE               PORTEbits.RE3 // Write Protect Check Input bit

#define SD_CS_TRIS          TRISBbits.TRISB1 // Chip Select TRIS bit
#define SD_CD_TRIS          TRISEbits.TRISE4 // Card Detect TRIS bit
#define SD_WE_TRIS          TRISEbits.TRISE3 // Write Protect Check TRIS bit
     
            
#define SPICON1             SPI2CON
#define SPISTAT             SPI2STAT
#define SPIBUF              SPI2BUF
#define SPISTAT_RBF         SPI2STATbits.SPIRBF
#define SPICON1bits         SPI2CONbits
#define SPISTATbits         SPI2STATbits
#define SPIENABLE           SPI2CONbits.ON
#define SPIBRG			    SPI2BRG

// Tris pins for SCK/SDI/SDO lines
#define SPICLOCK            TRISGbits.TRISG6 // The TRIS bit for the SCK pin
#define SPIIN               TRISGbits.TRISG7 // The TRIS bit for the SDI pin
#define SPIOUT              TRISGbits.TRISG8 // The TRIS bit for the SDO pin
#define putcSPI             putcSPI2
#define getcSPI             getcSPI2
#define OpenSPI(config1, config2)   OpenSPI2(config1, config2)
        
/* added from newer BfB code: */
        
// Description: The main SPI 2 control register
#define SPICON2             SPI2CON
#define SPICON2bits         SPI2CONbits


/* end of added code */

#endif
