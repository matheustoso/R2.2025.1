import glob
import matplotlib.pyplot as plt
import numpy as np


def main():
    OSPF_PROTOCOL = 'ospf'
    EIGRP_PROTOCOL = 'eigrp'
    R0 = 'r0'
    R1 = 'r1'
    R2 = 'r2'
    R3 = 'r3'
    R4 = 'r4'
    R5 = 'r5'

    ospf_files = glob.glob(f'../router/{OSPF_PROTOCOL}/logs/*.txt')
    r0_ospf_files = glob.glob(f'../router/{OSPF_PROTOCOL}/logs/{R0}/*.txt')
    r1_ospf_files = glob.glob(f'../router/{OSPF_PROTOCOL}/logs/{R1}/*.txt')
    r2_ospf_files = glob.glob(f'../router/{OSPF_PROTOCOL}/logs/{R2}/*.txt')
    r3_ospf_files = glob.glob(f'../router/{OSPF_PROTOCOL}/logs/{R3}/*.txt')
    r4_ospf_files = glob.glob(f'../router/{OSPF_PROTOCOL}/logs/{R4}/*.txt')
    r5_ospf_files = glob.glob(f'../router/{OSPF_PROTOCOL}/logs/{R5}/*.txt')

    eigrp_files = glob.glob(f'../router/{EIGRP_PROTOCOL}/logs/*.txt')
    r0_eigrp_files = glob.glob(f'../router/{EIGRP_PROTOCOL}/logs/{R0}/*.txt')
    r1_eigrp_files = glob.glob(f'../router/{EIGRP_PROTOCOL}/logs/{R1}/*.txt')
    r2_eigrp_files = glob.glob(f'../router/{EIGRP_PROTOCOL}/logs/{R2}/*.txt')
    r3_eigrp_files = glob.glob(f'../router/{EIGRP_PROTOCOL}/logs/{R3}/*.txt')
    r4_eigrp_files = glob.glob(f'../router/{EIGRP_PROTOCOL}/logs/{R4}/*.txt')
    r5_eigrp_files = glob.glob(f'../router/{EIGRP_PROTOCOL}/logs/{R5}/*.txt')

    ospf_routers = {
        R0: r0_ospf_files,
        R1: r1_ospf_files,
        R2: r2_ospf_files,
        R3: r3_ospf_files,
        R4: r4_ospf_files,
        R5: r5_ospf_files,
    }    
    eigrp_routers = {
        R0: r0_eigrp_files,
        R1: r1_eigrp_files,
        R2: r2_eigrp_files,
        R3: r3_eigrp_files,
        R4: r4_eigrp_files,
        R5: r5_eigrp_files,
    }


    plot_network_logs(ospf_files, OSPF_PROTOCOL)
    plot_network_logs(eigrp_files, EIGRP_PROTOCOL)
    plot_router_logs(ospf_routers, OSPF_PROTOCOL)
    plot_router_logs(eigrp_routers, EIGRP_PROTOCOL)


def plot_network_logs(files, protocol):
    convergence = 0

    for file in files:
        with open (file, 'r') as fi:
            
            name = fi.name.split('\\')[1].split('.')[0]
            
            if 'convergence' in name:
                convergence = int(fi.read())
                fig = plt.figure(figsize=(6, 1))
                fig.text(.15, .4, f'Convergência {protocol.upper()} em:', fontsize=20)
                fig.text(.85, .4, f'{convergence}s', ha='right', fontsize=20)
                plt.savefig(f'./{protocol}/{name}')

            elif 'ping' in name:
                for ln in fi:
                    if ln.startswith('round-trip'):
                        data = ln.split(' ')[3]
                        keys = ['min', 'avg', 'max']
                        labelValues = data.split('/')
                        values = [float(i) for i in labelValues]

                        y_pos = np.arange(len(values))
                        (packet_size, source, network, dest) = name.replace('ping', '').split('-')

                        fig, ax = plt.subplots()

                        ax.set_xticks(y_pos, labels=keys)
                        ax.set_ylabel('Latency (ms)')
                        ax.set_title(f'{protocol.upper()}. 50 Pings.\nPacket size {packet_size}. {source} to {dest} through {network}. ')
                        p = ax.bar(y_pos, values, align='center')
                        ax.set_ylim(0,0.8)
                        ax.bar_label(p, label_type='center')

                        fig.savefig(f'./{protocol}/{name}')
                        ax.clear()
                        plt.close(fig)

            else:
                print(f'Arquivo \'{name}\' inesperado.')

            print(f'Arquivo de log de rede {protocol.upper()} \'{name}\' processado com sucesso')


def plot_router_logs(routers, protocol):
    
    fig, ax = plt.subplots()
    values = []
    keys = []
    
    for router, files in routers.items():
        keys.append(router)
        
        for file in files:
            
            with open (file, 'r') as fi:
                name = fi.name.split('\\')[1].split('.')[0]
                
                if 'tcpdump' in name:
                    dump = fi.read()
                    values.append(dump.count('Hello'))     
                    print(f'Arquivos de log dos roteadores {protocol.upper()} \'{name}\' processado com sucesso')
                                   
        y_pos = np.arange(len(values))

        fig, ax = plt.subplots()

        ax.set_xticks(y_pos, labels=keys)
        ax.set_ylabel('Packets')
        ax.set_title(f'{protocol.upper()} packets in 60s by router')
        p = ax.bar(y_pos, values, align='center')
        ax.bar_label(p, label_type='center')
        ax.set_ylim(0,80)

        fig.savefig(f'./{protocol}/tcpdump')
        ax.clear()
        plt.close(fig)

if __name__=="__main__":
    main()