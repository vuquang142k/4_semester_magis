#define MAX_BUF 2
#define DATA_MESSAGES_COUNT 2

mtype {DATA, ACK, SYN, SYN_ACK, FIN_ACK};

chan client_to_server = [MAX_BUF] of {int, mtype};
chan server_to_client = [MAX_BUF] of {int, mtype};

proctype Client() {
    int data = 1337;
    int seq_num = 0;
    mtype msg_type;
    
    printf("The client sends a SYN.\n");
    client_to_server ! data, SYN;
    
    server_to_client ? _, msg_type;
    if
    :: (msg_type == SYN_ACK) ->
        printf("The client receives a SYN-ACK from the server and sends an ACK in response.\n");
        client_to_server ! 0, ACK;
    fi
     
    do
        :: seq_num < DATA_MESSAGES_COUNT ->
            printf("The client sends data %d\n", data);
            seq_num++;
            msg_type = DATA;
            client_to_server ! data, DATA;
            data++;
            server_to_client ? _, msg_type;
            if
            :: (msg_type == ACK) ->
                printf("The client receives an ACK from the server\n");
            fi
        
        :: else ->
            break;
    od
        
    server_to_client ? _, msg_type;
    if
    :: (msg_type == ACK) ->
        printf("The client receives an ACK from the server\n");
    fi

    printf("The client sends a FIN_ACK to the server\n")
    client_to_server ! 0, FIN_ACK;

    server_to_client ? _, msg_type;
    if
    :: (msg_type == ACK) ->
        printf("The client received an ACK from the server\n")
    fi

    server_to_client ? _, msg_type;
    if
    :: (msg_type == FIN_ACK) ->
        printf("The client received a FIN_ACK from the server\n")
    fi

    printf("The client sends the final ACK to the server and terminates its operation\n")
    client_to_server ! 0, ACK;
}

proctype Server() {
    int received_data;
    mtype msg_type;
    
    client_to_server ? _, msg_type;
    if
    :: (msg_type == SYN) ->
        printf("The server receives a SYN from the client and sends a SYN_ACK in response\n");
        server_to_client ! 0, SYN_ACK;
    fi
    
    client_to_server ? _, msg_type;
    if
    :: (msg_type == ACK) ->
        printf("The server receives an ACK from the client\n");
        server_to_client ! 0, ACK;
    fi
    
    printf("The server is waiting for data\n");
    client_to_server ? received_data, msg_type;

    do
        :: (msg_type == DATA) ->
            printf("The server receives data %d and sends an ACK back to the client\n", received_data);
            server_to_client ! 0, ACK;
            client_to_server ? received_data, msg_type;

        :: (msg_type == FIN_ACK) ->
            printf("The server receives a FIN_ACK from the client and sends an ACK and a FIN_ACK to the client\n")
            server_to_client ! 0, ACK;
            server_to_client ! 0, FIN_ACK;
            break;
    od

    client_to_server ? 0, msg_type;

    if
    :: (msg_type == ACK) ->
        printf("The server received an ACK from the client and is shutting down\n")
    fi
}

init {
    atomic {
        run Client();
        run Server();
    }
}
