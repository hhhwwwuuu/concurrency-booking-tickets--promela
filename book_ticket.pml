mtype = {UserA, UserB, ticket, success, failed}
chan book = [1] of {mtype}
chan chan_a = [0] of {mtype}
chan chan_b = [0] of {mtype}
int amount =1;
active  proctype User_A()
{
	//printf("%d",amount);
	if :: amount != 0 ->
			book!UserA;
			if :: chan_a?success ->		//get the ticket
					printf("A gets the ticket!\n");
				:: chan_a?failed ->		//failed get the ticket
					printf("A is Requested Failed!\n");
			fi
	:: else -> 
		printf("Not available!\n");
	fi
}

active proctype User_B()
{
	if
	::	amount != 0 ->	
		book!UserB;
		if
		:: chan_b?success ->
			printf("B gets the ticket!\n");
		:: chan_b?failed ->
			printf("B is Requested Failed!\n");
		fi
	:: else ->
		printf("Not available!\n");
	fi
}

active proctype system()
{
	bool flag =false;
	do :: flag == false ->
	if	:: book?UserA ->	//received the message from A
		if 
		:: amount > 0 ->
			amount--;
			chan_a!success;
		:: else ->
			chan_a!failed;
		fi;
		:: book?UserB ->	//received the message from B
		if
		::	amount > 0 ->
			amount--;
			chan_b!success;
		:: else ->
			chan_b!failed;
		fi
		:: timeout ->		//break the process
			flag = true;
	fi;
	:: else -> break
	od;
}
