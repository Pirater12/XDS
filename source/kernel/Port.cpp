#include "Kernel.h"

//tools


KPort::KPort(char* name, u32 maxconnection) : m_Client(new KClientPort(name, maxconnection, this)), m_Server(new KServerPort(name, maxconnection, this))
{
    strncpy(m_Name, name, 8);
    m_Client->AcquireReference();
    m_Server->AcquireReference();
}
KPort::~KPort()
{
    m_Client->ReleaseReference();
    m_Server->ReleaseReference();
}

bool KPort::IsInstanceOf(ClassName name) {
    if (name == KPort::name)
        return true;

    return super::IsInstanceOf(name);
}
