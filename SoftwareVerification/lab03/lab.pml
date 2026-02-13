#define MAX_BUF 2
#define DATA_MESSAGES_COUNT 2

mtype {DATA, ACK, SYN, SYN_ACK, FIN_ACK};

chan client_to_server = [MAX_BUF] of {int, mtype};
chan server_to_client = [MAX_BUF] of {int, mtype};

proctype Client() {
    int data = 1337;
    int seq_num = 0;
    mtype msg_type;
    
    printf("Клиент отправляет SYN\n");
    client_to_server ! data, SYN;
    
    server_to_client ? _, msg_type;
    if
    :: (msg_type == SYN_ACK) ->
        printf("Клиент получает SYN-ACK от сервера и направляет в ответ ACK\n");
        client_to_server ! 0, ACK;
    fi
     
    do
        :: seq_num < DATA_MESSAGES_COUNT ->
            printf("Клиент отправляет данные %d\n", data);
            seq_num++;
            msg_type = DATA;
            client_to_server ! data, DATA;
            data++;
            server_to_client ? _, msg_type;
            if
            :: (msg_type == ACK) ->
                printf("Клиент получает ACK от сервера\n");
            fi
        
        :: else ->
            break;
    od
        
    server_to_client ? _, msg_type;
    if
    :: (msg_type == ACK) ->
        printf("Клиент получает ACK от сервера\n");
    fi

    printf("Клиент направляет FIN_ACK серверу\n")
    client_to_server ! 0, FIN_ACK;

    server_to_client ? _, msg_type;
    if
    :: (msg_type == ACK) ->
        printf("Клиент получил ACK от сервера\n")
    fi

    server_to_client ? _, msg_type;
    if
    :: (msg_type == FIN_ACK) ->
        printf("Клиент получил FIN_ACK от сервера\n")
    fi

    printf("Клиент направляет последний ACK серверу и на этом заканчивает работу\n")
    client_to_server ! 0, ACK;
}

proctype Server() {
    int received_data;
    mtype msg_type;
    
    client_to_server ? _, msg_type;
    if
    :: (msg_type == SYN) ->
        printf("Сервер получает SYN от клиента и направляет в ответ SYN_ACK\n");
        server_to_client ! 0, SYN_ACK;
    fi
    
    client_to_server ? _, msg_type;
    if
    :: (msg_type == ACK) ->
        printf("Сервер получает ACK от клиента\n");
        server_to_client ! 0, ACK;
    fi
    
    printf("Сервер ожидает данные\n");
    client_to_server ? received_data, msg_type;

    do
        :: (msg_type == DATA) ->
            printf("Сервер получает данные %d и отправляет ACK в ответ клиенту\n", received_data);
            server_to_client ! 0, ACK;
            client_to_server ? received_data, msg_type;

        :: (msg_type == FIN_ACK) ->
            printf("Сервер получает FIN_ACK от клиента и направляет клиенту ACK и FIN_ACK\n")
            server_to_client ! 0, ACK;
            server_to_client ! 0, FIN_ACK;
            break;
    od

    client_to_server ? 0, msg_type;

    if
    :: (msg_type == ACK) ->
        printf("Сервер получил ACK от клиента и завершает работу\n")
    fi
}

init {
    atomic {
        run Client();
        run Server();
    }
}
