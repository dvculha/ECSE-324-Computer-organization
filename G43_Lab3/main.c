#include <stdio.h>

#include "./drivers/inc/LEDs.h"
#include "./drivers/inc/slider_switches.h"
#include "./drivers/inc/HEX_display.h"
#include "./drivers/inc/pushbuttons.h"
#include "./drivers/inc/HPS_TIM.h"
#include "./drivers/inc/ISRs.h"
#include "./drivers/inc/int_setup.h"

int iopart(){
	while(1){
		int sw_data = read_slider_switches_ASM();
		if (sw_data > 511){
			sw_data = sw_data - 512;
		}
		if (sw_data > 255){
			HEX_clear_ASM(63);
		}
		else{	
			sw_data = sw_data % 16;
			HEX_write_ASM(read_PB_data_ASM(), sw_data);
			HEX_clear_ASM(read_PB_edgecap_ASM());
			HEX_flood_ASM(HEX4|HEX5);
		}
			write_LEDs_ASM(read_slider_switches_ASM());
	}
}
int pollingstopwatch(){
	int count0 = 0, count1 = 0, count2 = 0, count3 = 0, count4 = 0, count5 = 0;

	HPS_TIM_config_t hps_tim;

	hps_tim.tim = TIM0;
	hps_tim.timeout = 10000000;
	hps_tim.LD_en = 1;
	hps_tim.INT_en = 1;
	hps_tim.enable = 1;

	HPS_TIM_config_ASM(&hps_tim);
	hps_tim.tim = TIM1;
	hps_tim.timeout = 50000000;
	HPS_TIM_config_ASM(&hps_tim);

	while(1){
		while (read_PB_data_ASM() % 2 == 0){
		if(HPS_TIM_read_INT_ASM(TIM1)){
			HPS_TIM_clear_INT_ASM(TIM1);
			//if(read_PB_data_ASM()==4)

			if (read_PB_data_ASM() >= 4){
				count1 = 0;
				count2 = 0;
				count3 = 0;
				count4 = 0;
				count5 = 0;
			}
			
		
			HEX_write_ASM(HEX0, count0);
			HEX_write_ASM(HEX1, count1);
			HEX_write_ASM(HEX2, count2);
			HEX_write_ASM(HEX3, count3);
			HEX_write_ASM(HEX4, count4);
			HEX_write_ASM(HEX5, count5);
		}

		}
		while (read_PB_data_ASM() % 4 != 2){
		if(HPS_TIM_read_INT_ASM(TIM0)){
			HPS_TIM_clear_INT_ASM(TIM0);
		//	if (++count0 == 10){
		//		count0 = 0;
				if (++count1 == 10){
					count1 = 0;
					if (++count2 == 10){
					count2 = 0;
						if(++count3 == 6){
						count3 = 0;
							if(++count4 == 10){
							count4 = 0;				
								if(++count5 == 6){
								count5 = 0;
								}
							}
						}
					}
				}			
		//	}
			//HEX_write_ASM(HEX0, count0);
			//HEX_flood_ASM(HEX0);
			//continue;
		}
		if(HPS_TIM_read_INT_ASM(TIM1)){
			HPS_TIM_clear_INT_ASM(TIM1);
			if(read_PB_data_ASM()==4){
				count1 = 0;
				count2 = 0;
				count3 = 0;
				count4 = 0;
				count5 = 0;
			}
			
		}
			HEX_write_ASM(HEX0, count0);
			HEX_write_ASM(HEX1, count1);
			HEX_write_ASM(HEX2, count2);
			HEX_write_ASM(HEX3, count3);
			HEX_write_ASM(HEX4, count4);
			HEX_write_ASM(HEX5, count5);
		}
	}
	return 0;

}
int rollingNumbers(){
	int count0 = 0, count1 = 0, count2 = 0, count3 = 0;

	HPS_TIM_config_t hps_tim;


	//hps_tim.tim = TIM0|TIM1|TIM2|TIM3;
	hps_tim.tim = TIM0|TIM1;
	hps_tim.timeout = 100000000;
	hps_tim.LD_en = 1;
	hps_tim.INT_en = 1;
	hps_tim.enable = 1;

	HPS_TIM_config_ASM(&hps_tim);
	hps_tim.tim = TIM2|TIM3;
	hps_tim.timeout = 25000000;
	HPS_TIM_config_ASM(&hps_tim);

	while(1){
		if(HPS_TIM_read_INT_ASM(TIM0)){
		//printf("timer1\n");
			HPS_TIM_clear_INT_ASM(TIM0);
			if (++count0 == 16)
				count0 = 0;
		}
		if(HPS_TIM_read_INT_ASM(TIM1)){
			HPS_TIM_clear_INT_ASM(TIM1);
			if (++count1 == 16)
				count1 = 0;
		}
		if(HPS_TIM_read_INT_ASM(TIM2)){
		printf("timer3");
			HPS_TIM_clear_INT_ASM(TIM2);
			if (++count2 == 16)
				count2 = 0;
		}
		if(HPS_TIM_read_INT_ASM(TIM3)){
		printf("timer4");
			HPS_TIM_clear_INT_ASM(TIM3);
			if (++count3 == 16)
				count3 = 0;
		}
		HEX_write_ASM(HEX0|HEX1|HEX2|HEX3, count3);
	}
	return 0;
}

int interruptStopwatch(){

	int_setup(1, (int []){199});

	int count0 = 0, count1 = 0, count2 = 0, count3 = 0, count4 = 0, count5 = 0;

	HPS_TIM_config_t hps_tim;

	hps_tim.tim = TIM0;
	hps_tim.timeout = 10000000;
	hps_tim.LD_en = 1;
	hps_tim.INT_en = 1;
	hps_tim.enable = 1;

	HPS_TIM_config_ASM(&hps_tim);

	while(1){
		while (read_PB_data_ASM() % 2 == 0){

			if (read_PB_data_ASM() >= 4){
				count1 = 0;
				count2 = 0;
				count3 = 0;
				count4 = 0;
				count5 = 0;
			}
			
		
			HEX_write_ASM(HEX0, count0);
			HEX_write_ASM(HEX1, count1);
			HEX_write_ASM(HEX2, count2);
			HEX_write_ASM(HEX3, count3);
			HEX_write_ASM(HEX4, count4);
			HEX_write_ASM(HEX5, count5);
		}

		
		while (read_PB_data_ASM() % 4 != 2){
		if(hps_tim0_int_flag){
			hps_tim0_int_flag = 0;
			if (++count1 == 10){
				count1 = 0;
				if (++count2 == 10){
					count2 = 0;
					if(++count3 == 6){
						count3 = 0;
						if(++count4 == 10){
							count4 = 0;				
							if(++count5 == 6){
								count5 = 0;
							}
						}
					}
				}
			}			
			if(read_PB_data_ASM()==4){
				count1 = 0;
				count2 = 0;
				count3 = 0;
				count4 = 0;
				count5 = 0;
			}
		}
			HEX_write_ASM(HEX0, count0);
			HEX_write_ASM(HEX1, count1);
			HEX_write_ASM(HEX2, count2);
			HEX_write_ASM(HEX3, count3);
			HEX_write_ASM(HEX4, count4);
			HEX_write_ASM(HEX5, count5);
		}
	}
	
	return 0;

}
int main(){
	//iopart();
	//rollingNumbers();
	pollingstopwatch();
	//interruptStopwatch();

	return 0;
}
