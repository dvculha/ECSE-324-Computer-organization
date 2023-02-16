extern int MAX_2(int x, int y);

int main(){
  	int a[5] = {1, -20, 3, 4, 5};
    int n = sizeof(a)/sizeof(a[0]);
	int max_val = a[0];
	int i = 0;
	for (i = 0; i < n; i++){
		max_val = MAX_2(a[i], max_val);
	}
	return max_val;
}
