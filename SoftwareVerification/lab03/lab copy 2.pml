#define MAX_BUF 1

mtype {DATA, ACK, SYN, SYN_ACK, FIN};

chan client_to_server = [MAX_BUF] of {int, mtype};
chan server_to_client = [MAX_BUF] of {int, mtype};

proctype Client() {
    int data = 0;
    int seq_num = 0;
    mtype msg_type;
    
    // Клиент инициирует установку соединения (SYN)
    printf("Клиент отправляет SYN\n");
    client_to_server ! data, SYN;
    
    // Ожидаем SYN-ACK от сервера
    server_to_client ? _, msg_type;
    if
    :: (msg_type == SYN_ACK) ->
        printf("Клиент получает SYN-ACK от сервера и направляет в ответ ACK\n");
        seq_num++;
        // Отправляем подтверждение (ACK) серверу
        client_to_server ! 0, ACK;
    fi
    
    // Ожидаем подтверждение от сервера
    server_to_client ? _, msg_type;
    if
    :: (msg_type == ACK) ->
        printf("Клиент получает ACK от сервера\n");
    fi
    
    // После установки соединения отправляем данные
    printf("Клиент отправляет данные %d\n", data);
    seq_num++;
    msg_type = DATA;
    client_to_server ! data, DATA;
    data++;
    
    // Ожидаем подтверждение от сервера
    server_to_client ? _, msg_type;
    if
    :: (msg_type == ACK) ->
        printf("Клиент получает ACK от сервера\n");
    fi
}

proctype Server() {
    int received_data;
    mtype msg_type;
    
    // Ожидаем SYN от клиента
    client_to_server ? _, msg_type;
    if
    :: (msg_type == SYN) ->
        printf("Сервер получает SYN от клиента и направляет в ответ SYN_ACK\n");
        // Отправляем SYN-ACK клиенту
        server_to_client ! 0, SYN_ACK;
    fi
    
    // Ожидаем подтверждение (ACK) от клиента
    client_to_server ? _, msg_type;
    if
    :: (msg_type == ACK) ->
        printf("Сервер получает ACK от клиента и отправляет в ответ ACK\n");
        server_to_client ! 0, ACK;
    fi
    
    // Ожидаем данные от клиента
    printf("Сервер ожидает данные\n");
    client_to_server ? received_data, msg_type;
    if
    :: (msg_type == DATA) ->
        printf("Сервер получает данные %d и отправляет ACK в ответ клиенту\n", received_data);
        // Отправляем подтверждение (ACK) клиенту
        server_to_client ! 0, ACK;
    fi
}

init {
    atomic {
        run Client();
        run Server();
    }
}
