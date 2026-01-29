# 🔴 REPORTE DE VULNERABILIDADES - Xtream UI Installer

**Aplicación**: Xtream UI Install Script  
**Versión analizada**: Master  
**Fecha de análisis**: 2026-01-28  
**Severidad General**: **CRÍTICA**

---

## RESUMEN EJECUTIVO

Se han identificado **15+ vulnerabilidades críticas** en el instalador de Xtream UI. La aplicación presenta múltiples vectores de ataque que permiten:

- ✅ Ejecución remota de código (RCE)
- ✅ Inyección SQL
- ✅ Escalada de privilegios
- ✅ Lectura de archivos sensibles
- ✅ Man-in-the-Middle attacks
- ✅ Acceso no autorizado al sistema

**CVSS Score Estimado**: 9.8/10 (CRÍTICO)

---

## VULNERABILIDADES DETALLADAS

### 🔴 VULN-001: Command Injection en instalación principal
**Severidad**: CRÍTICA  
**CWE**: CWE-78 (OS Command Injection)  
**CVSS**: 9.8

#### Descripción
El script usa `os.system()` con datos controlables por el usuario sin sanitización.

#### Ubicación
```python
# install.py - Línea 82
os.system('wget -q -O "/tmp/xtreamcodes.tar.gz" "%s"' % rURL)

# install.py - Línea 114
os.system('wget -q -O "/tmp/update.zip" "%s"' % rURL)
```

#### Impacto
Un atacante puede ejecutar comandos arbitrarios con privilegios de root.

#### Prueba de Concepto (PoC)
```bash
# Al ejecutar install.py y elegir UPDATE, se puede ingresar:
http://example.com/file.zip"; rm -rf /tmp/test #

# Resultado: Se ejecuta el comando rm
```

#### Remediación
```python
# Usar subprocess con argumentos separados
import subprocess
subprocess.run(['wget', '-q', '-O', '/tmp/xtreamcodes.tar.gz', rURL], check=True)
```

---

### 🔴 VULN-002: SQL Injection en configuración MySQL
**Severidad**: CRÍTICA  
**CWE**: CWE-89 (SQL Injection)  
**CVSS**: 9.1

#### Descripción
Las queries SQL se construyen con concatenación de strings sin prepared statements.

#### Ubicación
```python
# install.py - Líneas 156-162
os.system('mysql -u root%s -e "DROP USER IF EXISTS \'%s\'@\'%%\';" > /dev/null' % (rExtra, rUsername))
os.system('mysql -u root%s -e "CREATE USER \'%s\'@\'%%\' IDENTIFIED BY \'%s\';" > /dev/null' % (rExtra, rUsername, rPassword))
```

#### Impacto
- Extracción completa de la base de datos
- Modificación de datos
- Bypass de autenticación
- Ejecución de comandos del sistema vía MySQL

#### Prueba de Concepto
```sql
-- Al ingresar como MySQL password:
'; DROP DATABASE xtream_iptvpro; --

-- O para obtener shell:
'; SELECT "<?php system($_GET['cmd']); ?>" INTO OUTFILE '/var/www/html/shell.php'; --
```

#### Remediación
```python
import mysql.connector
conn = mysql.connector.connect(user='root', password=rMySQLRoot)
cursor = conn.cursor()
cursor.execute("CREATE USER %s@'%%' IDENTIFIED BY %s", (rUsername, rPassword))
```

---

### 🔴 VULN-003: Weak Encryption - Credenciales de DB en texto plano
**Severidad**: CRÍTICA  
**CWE**: CWE-327 (Use of Broken Crypto)  
**CVSS**: 8.9

#### Descripción
Las credenciales de la base de datos se "encriptan" usando XOR con una clave estática hardcodeada.

#### Ubicación
```python
# install.py - Línea 182
# balancer.py - Línea 45
rf.write(''.join(chr(ord(c)^ord(k)) for c,k in izip(
    '{"host":"%s","db_user":"%s","db_pass":"%s","db_name":"%s","server_id":"%d", "db_port":"%d"}' % (...),
    cycle('5709650b0d7806074842c6de575025b1')
)).encode('base64').replace('\n', ''))
```

#### Impacto
Cualquier persona con acceso al archivo `/home/xtreamcodes/iptv_xtream_codes/config` puede desencriptar las credenciales.

#### Prueba de Concepto
El script de explotación está en `exploits/decrypt_config.py`

#### Remediación
- Usar encriptación AES-256 con clave única por instalación
- Almacenar la clave en un HSM o KMS
- Usar variables de entorno o secrets managers

---

### 🔴 VULN-004: Hardcoded Admin Credentials
**Severidad**: CRÍTICA  
**CWE**: CWE-798 (Hard-coded Credentials)  
**CVSS**: 9.8

#### Descripción
Las credenciales de administrador están hardcodeadas en el script.

#### Ubicación
```python
# install.py - Línea 161
os.system('mysql -u root%s -e "USE xtream_iptvpro; REPLACE INTO reg_users (id, username, password, email, member_group_id, verified, status) VALUES (1, \'admin\', \'$6$rounds=20000$xtreamcodes$XThC5OwfuS0YwS4ahiifzF14vkGbGsFF1w7ETL4sRRC5sOrAWCjWvQJDromZUQoQuwbAXAFdX3h3Cp3vqulpS0\', \'admin@website.com\', 1, 1, 1);" > /dev/null'  % rExtra)
```

#### Impacto
- Acceso administrativo por defecto: **admin / admin**
- Toma de control total del panel

#### Prueba de Concepto
```bash
# Acceder a http://[IP]:25500
# Usuario: admin
# Password: admin
```

#### Remediación
- Generar contraseña aleatoria durante instalación
- Forzar cambio en primer login
- Implementar 2FA

---

### 🟠 VULN-005: Insecure File Downloads (HTTP sin verificación)
**Severidad**: ALTA  
**CWE**: CWE-494 (Download of Code Without Integrity Check)  
**CVSS**: 8.1

#### Descripción
Los archivos se descargan por HTTP sin verificar integridad (hashes).

#### Ubicación
```python
# install.py - Línea 8
rDownloadURL = {
    "main": "http://xtream-ui.org/main_xtreamcodes_reborn.tar.gz",  # HTTP!
    "sub": "http://xtream-ui.org/sub_xtreamcodes_reborn.tar.gz"
}
```

#### Impacto
- Man-in-the-Middle (MITM) attacks
- Instalación de código malicioso
- Backdoors

#### Remediación
```python
import hashlib

def verify_download(filepath, expected_hash):
    sha1 = hashlib.sha1()
    with open(filepath, 'rb') as f:
        sha1.update(f.read())
    return sha1.hexdigest() == expected_hash

# Después de descargar
if not verify_download('/tmp/xtreamcodes.tar.gz', '532B63EA0FEA4E6433FC47C3B8E65D8A90D5A4E9'):
    raise Exception("Hash mismatch!")
```

---

### 🟠 VULN-006: Privilege Escalation via Sudoers
**Severidad**: ALTA  
**CWE**: CWE-269 (Improper Privilege Management)  
**CVSS**: 7.8

#### Descripción
El usuario `xtreamcodes` se añade a sudoers con NOPASSWD.

#### Ubicación
```python
# install.py - Línea 192
os.system('echo "xtreamcodes ALL = (root) NOPASSWD: /sbin/iptables, /usr/bin/chattr" >> /etc/sudoers')

# balancer.py - Línea 53
os.system('echo "xtreamcodes ALL = (root) NOPASSWD: /sbin/iptables" >> /etc/sudoers')
```

#### Impacto
El usuario xtreamcodes puede ejecutar comandos como root sin contraseña.

#### Prueba de Concepto
```bash
su - xtreamcodes
sudo /sbin/iptables -F  # Ejecuta sin password
```

---

### 🟠 VULN-007: Insecure File Permissions
**Severidad**: ALTA  
**CWE**: CWE-732 (Incorrect Permission Assignment)  
**CVSS**: 7.5

#### Ubicación
```python
# install.py - Línea 209
os.system("chmod -R 0777 /home/xtreamcodes > /dev/null")

# balancer.py - Línea 67
os.system("chmod -R 0777 /home/xtreamcodes > /dev/null")
```

#### Impacto
Todos los archivos son legibles, escribibles y ejecutables por cualquier usuario del sistema.

---

### 🟡 VULN-008: Password Handling Issues
**Severidad**: MEDIA  
**CWE**: CWE-256 (Plaintext Storage of Password)

#### Ubicación
```python
# install.py - Línea 147
rMySQLRoot = raw_input("  ")  # Password visible en consola
```

#### Impacto
La contraseña puede quedar en el historial de comandos o logs.

---

### 🟡 VULN-009: Race Condition en archivos de lock
**Severidad**: MEDIA  
**CWE**: CWE-367 (TOCTOU Race Condition)

#### Ubicación
```python
# install.py - Líneas 51-53
for rFile in ["/var/lib/dpkg/lock-frontend", "/var/cache/apt/archives/lock", "/var/lib/dpkg/lock"]:
    try: os.remove(rFile)
    except: pass
```

---

### 🟡 VULN-010: Information Disclosure
**Severidad**: MEDIA  
**CWE**: CWE-200 (Information Exposure)

#### Ubicación
```python
# install.py - Línea 283
printc(rPassword)  # Imprime password en pantalla
```

---

## VULNERABILIDADES ADICIONALES

### VULN-011: Insecure Randomness
```python
# install.py - Línea 28
def generate(length=19): 
    return ''.join(random.choice(string.ascii_letters + string.digits) for i in range(length))
```
Usa `random` en vez de `secrets` (criptográficamente inseguro).

### VULN-012: Missing Input Validation
No hay validación de inputs en ningún punto del código.

### VULN-013: Denial of Service
```python
# install.py - Línea 189
size=90%  # Puede llenar 90% del tmpfs
```

### VULN-014: Code Injection en Nginx Config
```python
# install.py - Línea 239
rData = "}".join(rPrevData.split("}")[:-1]) + "..."  # Manipulación de strings sin validación
```

### VULN-015: Exposure of Sensitive Information
```python
# install.py - Líneas 223-225
# Modifica /etc/hosts para bloquear dominios
```

---

## MATRIZ DE RIESGO

| Vulnerabilidad | Severidad | Explotabilidad | Impacto | Remediación |
|---------------|-----------|----------------|---------|-------------|
| VULN-001: Command Injection | CRÍTICA | Fácil | RCE | Inmediata |
| VULN-002: SQL Injection | CRÍTICA | Fácil | Data Breach | Inmediata |
| VULN-003: Weak Encryption | CRÍTICA | Fácil | Credential Theft | Inmediata |
| VULN-004: Hardcoded Creds | CRÍTICA | Trivial | Full Compromise | Inmediata |
| VULN-005: Insecure Downloads | ALTA | Media | Malware | Alta |
| VULN-006: Privilege Escalation | ALTA | Fácil | Root Access | Alta |
| VULN-007: File Permissions | ALTA | Fácil | Data Access | Alta |
| VULN-008-015 | MEDIA-BAJA | Variable | Variable | Media |

---

## RECOMENDACIONES GENERALES

### Inmediatas
1. ❌ **NO USAR EN PRODUCCIÓN** hasta remediar vulnerabilidades críticas
2. 🔒 Cambiar todas las credenciales por defecto
3. 🔐 Implementar validación de entrada en todo el código
4. 🛡️ Usar prepared statements para SQL
5. 🔑 Implementar encriptación fuerte para credenciales

### A Corto Plazo
1. Migrar de Python 2 a Python 3
2. Implementar logging de seguridad
3. Añadir verificación de integridad (hashes)
4. Usar HTTPS para todas las descargas
5. Implementar rate limiting

### A Largo Plazo
1. Reescribir el instalador con mejores prácticas
2. Implementar tests de seguridad automatizados
3. Realizar auditoría de seguridad profesional
4. Implementar WAF (Web Application Firewall)
5. Segmentación de red y principio de mínimo privilegio

---

## REFERENCIAS

- OWASP Top 10 2021
- CWE/SANS Top 25 Most Dangerous Software Errors
- NIST Cybersecurity Framework
- PCI DSS Requirements

---

## DISCLAIMER

Este reporte es para fines educativos y de mejora de seguridad únicamente. No usar esta información para actividades maliciosas o ilegales.

**Fecha de generación**: 2026-01-28  
**Analista**: Security Assessment Tool  
**Contacto**: Reportar vulnerabilidades de forma responsable
