mtype ={user,success,failed}
chan resever = [1] of {mtype}
chan book = [0] of {mtype}
int seat = 5
active [6] proctype User()
{
	if
	:: seat != 0 ->
		resever!user;
		if	:: book?success ->
				printf("%d gets the ticket!\n",_pid);
			:: book?failed ->
				printf("%d is requested failed!\n",_pid);
		fi
	:: else -> 
		printf("%d is not available!\n",_pid);
	fi
}
active proctype system()
{
	bool flag = false;
	do :: flag == false ->
		if	
		:: resever?user ->
			if
			::	seat > 0 ->
				seat--;
				book!success;
			::	else ->
				book!failed;
			fi;
		::	timeout ->
			flag = true;
		fi;
	::	else -> break;
	od;
}
